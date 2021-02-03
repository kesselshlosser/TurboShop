<?PHP

/**
* Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com/
 *
 * Этот класс использует шаблоны article.tpl и post.tpl
 *
 */

require_once('View.php');

class ArticlesView extends View
{
	public function fetch()
	{
		$url = $this->request->get('article_url', 'string');
		
		// Если указан адрес поста,
		if(!empty($url))
		{
			// Выводим пост
			return $this->fetch_article($url);
		}
		else
		{
			// Иначе выводим ленту блога
			return $this->fetch_articles($url);
		}
	}
	
	private function fetch_article($url)
	{
		// Выбираем пост из базы
		$post = $this->articles->get_article($url);
		
		// Количество просмотров
        if($post->visible && empty($_SESSION['admin']))
        $this->articles->update_views($post->id);
		
		// Если не найден - ошибка
		if(!$post || (!$post->visible && empty($_SESSION['admin'])))
			return false;
		
		// Last-Modified 
		$LastModified_unix = strtotime($post->last_modified); // время последнего изменения страницы
		$LastModified = gmdate("D, d M Y H:i:s \G\M\T", $LastModified_unix);
		$IfModifiedSince = false;
		if (isset($_ENV['HTTP_IF_MODIFIED_SINCE']))
			$IfModifiedSince = strtotime(substr($_ENV['HTTP_IF_MODIFIED_SINCE'], 5));  
		if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']))
			$IfModifiedSince = strtotime(substr($_SERVER['HTTP_IF_MODIFIED_SINCE'], 5));
		if ($IfModifiedSince && $IfModifiedSince >= $LastModified_unix) {
			header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
			exit;
		}
		header('Last-Modified: '. $LastModified);
		
		// Автозаполнение имени для формы комментария
		if(!empty($this->user))
			$this->design->assign('comment_name', $this->user->name);

		
		// Принимаем комментарий
		if ($this->request->method('post') && $this->request->post('comment'))
		{
			$comment = new stdClass;
			$comment->name = $this->request->post('name');
			$comment->text = $this->request->post('text');
            $captcha_code =  $this->request->post('captcha_code', 'string');
			
			if ($this->settings->comments_tree_articles == "on") {
				$comment->parent_id = $this->request->post('parent_id');
				$comment->admin = $this->request->post('admin');
			}
			
			// Передадим комментарий обратно в шаблон - при ошибке нужно будет заполнить форму
			$this->design->assign('comment_text', $comment->text);
			$this->design->assign('comment_name', $comment->name);
			
			if ($this->settings->comments_tree_articles == "on") {
				$this->design->assign('parent_id', $comment->parent_id);
			}
			
			// Проверяем капчу и заполнение формы
			if ($this->settings->captcha_article && ($_SESSION['captcha_article'] != $captcha_code || empty($captcha_code)))
			{
				$this->design->assign('error', 'captcha');
			}
			elseif (empty($comment->name))
			{
				$this->design->assign('error', 'empty_name');
			}
			elseif (empty($comment->text))
			{
				$this->design->assign('error', 'empty_comment');
			}
			else
			{
				// Создаем комментарий
				$comment->object_id = $post->id;
				$comment->type      = 'article';
				$comment->ip        = $_SERVER['REMOTE_ADDR'];
				
				// Если были одобренные комментарии от текущего ip, одобряем сразу
				$this->db->query("SELECT 1 FROM __comments WHERE approved=1 AND ip=? LIMIT 1", $comment->ip);
				if($this->db->num_rows()>0)
					$comment->approved = 1;
				
				// Добавляем комментарий в базу
				$comment_id = $this->comments->add_comment($comment);
				
				// Отправляем email
				$this->notify->email_comment_admin($comment_id);
				
                // Приберем сохраненную капчу, иначе можно отключить загрузку рисунков и постить старую
				unset($_SESSION['captcha_code']);
				header('location: '.$_SERVER['REQUEST_URI'].'#comment_'.$comment_id);
			}			
		}
		
		if ($this->settings->comments_tree_articles == "on") {
			$filter = array();          
			$filter['type'] = 'article';
			$filter['object_id'] = $post->id;
			$filter['approved'] = 1;
			$filter['ip'] = $_SERVER['REMOTE_ADDR'];
			
			// Сортировка комментариев, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
			if($sort = $this->request->get('sort', 'string'))
				$_SESSION['sort'] = $sort;		
			if (!empty($_SESSION['sort']))
				$filter['sort'] = $_SESSION['sort'];			
			else
				$filter['sort'] = 'rate';			
			$this->design->assign('sort', $filter['sort']);
			
			// Считываем общее кол-во коментов для рассчета страниц          
			$comments_count = $this->comments->count_comments($filter);
			
			// Комментарии к посту
			$comments = $this->comments->get_comments_tree($filter);
			$this->design->assign('comments_count', $comments_count);
		}
		else
		{
			$comments = $this->comments->get_comments(array('type'=>'article', 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR']));
		}	
		
		$this->design->assign('comments', $comments);
		$this->design->assign('post', $post);
      
		// Категория
		$this->design->assign('articles_category', $this->articles_categories->get_articles_category(intval($post->category_id)));
		
		// Теги
		$tags = explode(',',$post->meta_keywords);
		$this->design->assign('tags', array_map("trim",$tags));
		
		// Соседние записи
		$this->design->assign('next_post', $this->articles->get_next_article($post->id));
		$this->design->assign('prev_post', $this->articles->get_prev_article($post->id));
		
		// Мета-теги
		$this->design->assign('meta_title', $post->meta_title);
		$this->design->assign('meta_keywords', $post->meta_keywords);
		$this->design->assign('meta_description', $post->meta_description);
		
		$auto_meta = new StdClass;
        
        $auto_meta->title       = $this->seo->article_meta_title       ? $this->seo->article_meta_title       : '';
        $auto_meta->keywords    = $this->seo->article_meta_keywords    ? $this->seo->article_meta_keywords    : '';
        $auto_meta->description = $this->seo->article_meta_description ? $this->seo->article_meta_description : '';
        
        $auto_meta_parts = array(
                                '{post}' => ($post ? $post->name : ''),
                                '{page}' => ($this->page ? $this->page->header : ''),
                                '{site_url}' => ($this->seo->am_url ? $this->seo->am_url : ''),
                                '{site_name}' => ($this->seo->am_name ? $this->seo->am_name : ''),
                                '{site_phone}' => ($this->seo->am_phone ? $this->seo->am_phone : ''),
                                '{site_email}' => ($this->seo->am_email ? $this->seo->am_email : ''),
                            );
        
        $auto_meta->title = strtr($auto_meta->title, $auto_meta_parts);
        $auto_meta->keywords = strtr($auto_meta->keywords, $auto_meta_parts);
        $auto_meta->description = strtr($auto_meta->description, $auto_meta_parts);
        
        $auto_meta->title = preg_replace("/\{.*\}/",'',$auto_meta->title);
        $auto_meta->keywords = preg_replace("/\{.*\}/",'',$auto_meta->keywords);
        $auto_meta->description = preg_replace("/\{.*\}/",'',$auto_meta->description);
        
        $this->design->assign('auto_meta', $auto_meta); 
		
		return $this->design->fetch('article.tpl');
	}	
	
	// Отображение списка постов
	private function fetch_articles()
	{

		$filter = array();
		
		// Если задано ключевое слово
		$keyword = $this->request->get('keyword');
		if (!empty($keyword))
		{
			$this->design->assign('keyword', $keyword);
			$filter['keyword'] = $keyword;
		}
	
		// GET-Параметры
		$category_url = $this->request->get('category', 'string');
		
		// Выберем текущую категорию
		if (!empty($category_url))
		{
			$category = $this->articles_categories->get_articles_category((string)$category_url);
			if (empty($category) || (!$category->visible && empty($_SESSION['admin'])))
				return false;
			$this->design->assign('articles_category', $category);
			
			$filter['category_id'] = $category->children;
		}    	

		// Сортировка постов, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('sort', 'string'))
			$_SESSION['sort'] = $sort;		
		if (!empty($_SESSION['sort']))
			$filter['sort'] = $_SESSION['sort'];			
		else
			$filter['sort'] = 'position';			
		$this->design->assign('sort', $filter['sort']);
	
		// Количество постов на 1 странице
		$items_per_page = $this->settings->articles_num;

        // Выбираем только видимые посты
		$filter['visible'] = 1;
		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'integer');
		
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);

		// Вычисляем количество страниц
		$posts_count = $this->articles->count_articles($filter);

		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $posts_count;	

		$pages_num = ceil($posts_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Выбираем статьи из базы
		$posts = $this->articles->get_articles($filter);
		
		foreach ($posts as $post) {
            $post->comments = count($this->comments->get_comments(array('type'=>'article', 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR'])));
			$post->category = $this->articles_categories->get_articles_category(intval($post->category_id));
		}
		
        // Передаем в шаблон
		$this->design->assign('posts', $posts);
		
		// Устанавливаем мета-теги в зависимости от запроса
		 $auto_meta = new StdClass;
        
        $auto_meta->title = "";
        $auto_meta->keywords = "";
        $auto_meta->description = "";
        
        $auto_meta_parts = @array(
                                '{category}' => ($category ? $category->name : ''),
                                '{page}' => ($this->page ? $this->page->header : ''),
                                '{site_url}' => ($this->seo->am_url ? $this->seo->am_url : ''),
                                '{site_name}' => ($this->seo->am_name ? $this->seo->am_name : ''),
                                '{site_phone}' => ($this->seo->am_phone ? $this->seo->am_phone : ''),
                                '{site_email}' => ($this->seo->am_email ? $this->seo->am_email : ''),
                            );
		
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			
			$LastModified_unix = strtotime($this->page->last_modified);
            
            $auto_meta->title       = $this->seo->page_meta_title       ? $this->seo->page_meta_title       : '';
            $auto_meta->keywords    = $this->seo->page_meta_keywords    ? $this->seo->page_meta_keywords    : '';
            $auto_meta->description = $this->seo->page_meta_description ? $this->seo->page_meta_description : '';
			
		}
		elseif(isset($category))
		{
			$this->design->assign('meta_title', $category->meta_title);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description);
			
			 $LastModified_unix = strtotime($category->last_modified);
            
            $auto_meta->title       = $this->seo->category_article_meta_title       ? $this->seo->category_article_meta_title       : '';
            $auto_meta->keywords    = $this->seo->category_article_meta_keywords    ? $this->seo->category_article_meta_keywords    : '';
            $auto_meta->description = $this->seo->category_article_meta_description ? $this->seo->category_article_meta_description : '';
		}
		elseif(isset($keyword))
		{
			$this->design->assign('meta_title', $keyword);
		}
		
		$auto_meta->title = strtr($auto_meta->title, $auto_meta_parts);
        $auto_meta->keywords = strtr($auto_meta->keywords, $auto_meta_parts);
        $auto_meta->description = strtr($auto_meta->description, $auto_meta_parts);
        
        $auto_meta->title = preg_replace("/\{.*\}/",'',$auto_meta->title);
        $auto_meta->keywords = preg_replace("/\{.*\}/",'',$auto_meta->keywords);
        $auto_meta->description = preg_replace("/\{.*\}/",'',$auto_meta->description);
        
        $this->design->assign('auto_meta', $auto_meta);
		
		// Last-Modified 
		if(isset($LastModified_unix)){
    		$LastModified = gmdate("D, d M Y H:i:s \G\M\T", $LastModified_unix);
    		$IfModifiedSince = false;
    		if (isset($_ENV['HTTP_IF_MODIFIED_SINCE']))
    			$IfModifiedSince = strtotime(substr($_ENV['HTTP_IF_MODIFIED_SINCE'], 5));  
    		if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']))
    			$IfModifiedSince = strtotime(substr($_SERVER['HTTP_IF_MODIFIED_SINCE'], 5));
    		if ($IfModifiedSince && $IfModifiedSince >= $LastModified_unix) {
    			header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
    			exit;
    		}
    		header('Last-Modified: '. $LastModified);
        }
		
		$body = $this->design->fetch('articles.tpl');
		
		return $body;
	}	
}
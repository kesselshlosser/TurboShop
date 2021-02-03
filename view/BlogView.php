<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com/
 *
 * Этот класс использует шаблоны blog.tpl и post.tpl
 *
 */

require_once('View.php');

class BlogView extends View
{
	public function fetch()
	{
		$url = $this->request->get('url', 'string');
		
		// Если указан адрес поста,
		if(!empty($url))
		{
			// Выводим пост
			return $this->fetch_post($url);
		}
		else
		{
			// Иначе выводим ленту блога
			return $this->fetch_blog($url);
		}
	}
	
	private function fetch_post($url)
	{
		// Выбираем пост из базы
		$post = $this->blog->get_post($url);
		
		// Количество просмотров
        if($post->visible && empty($_SESSION['admin']))
        $this->blog->update_views($post->id);
		
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
			
			if ($this->settings->comments_tree_blog == "on") {
				$comment->parent_id = $this->request->post('parent_id');
				$comment->admin = $this->request->post('admin');
			}
			
			// Передадим комментарий обратно в шаблон - при ошибке нужно будет заполнить форму
			$this->design->assign('comment_text', $comment->text);
			$this->design->assign('comment_name', $comment->name);
			
			if ($this->settings->comments_tree_blog == "on") {
				$this->design->assign('parent_id', $comment->parent_id);
			}
			
			// Проверяем капчу и заполнение формы
			if ($this->settings->captcha_post && ($_SESSION['captcha_post'] != $captcha_code || empty($captcha_code)))
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
				$comment->type      = 'blog';
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
		
		if ($this->settings->comments_tree_blog == "on") {
			$filter = array();          
			$filter['type'] = 'blog';
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
			
			// Древовидные комментарии к посту
			$comments = $this->comments->get_comments_tree($filter);
			$this->design->assign('comments_count', $comments_count);
		
		}
		else
		{
			// Комментарии к посту
			$comments = $this->comments->get_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR']));
		}
		
		$this->design->assign('comments', $comments);
		$this->design->assign('post', $post);
		
		// Теги
		$tags = explode(',',$post->meta_keywords);
		$this->design->assign('tags', array_map("trim", $tags));
		
		// Соседние записи
		$this->design->assign('next_post', $this->blog->get_next_post($post->id));
		$this->design->assign('prev_post', $this->blog->get_prev_post($post->id));
		
		// Мета-теги
		$this->design->assign('meta_title', $post->meta_title);
		$this->design->assign('meta_keywords', $post->meta_keywords);
		$this->design->assign('meta_description', $post->meta_description);
        
        $auto_meta = new StdClass;
        
        $auto_meta->title       = $this->seo->post_meta_title       ? $this->seo->post_meta_title       : '';
        $auto_meta->keywords    = $this->seo->post_meta_keywords    ? $this->seo->post_meta_keywords    : '';
        $auto_meta->description = $this->seo->post_meta_description ? $this->seo->post_meta_description : '';
        
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
		
		return $this->design->fetch('post.tpl');
	}	
	
	// Отображение списка постов
	private function fetch_blog()
	{

		$filter = array();
		
		// Если задано ключевое слово
		$keyword = $this->request->get('keyword');
		if (!empty($keyword))
		{
			$this->design->assign('keyword', $keyword);
			$filter['keyword'] = $keyword;
		}
		
		// Сортировка постов, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('sort', 'string'))
			$_SESSION['sort'] = $sort;		
		if (!empty($_SESSION['sort']))
			$filter['sort'] = $_SESSION['sort'];			
		else
			$filter['sort'] = 'date';			
		$this->design->assign('sort', $filter['sort']);
		
		// Количество постов на 1 странице
		$items_per_page = $this->settings->blog_num;
		
		// Выбираем только видимые посты
		$filter['visible'] = 1;
		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'integer');
		
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);

		// Вычисляем количество страниц
		$posts_count = $this->blog->count_posts($filter);

		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $posts_count;	

		$pages_num = ceil($posts_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Выбираем статьи из базы
		$posts = $this->blog->get_posts($filter);
			
		foreach ($posts as $post) {
            $post->comments = count($this->comments->get_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR'])));
        }	
		
		// Передаем в шаблон
		$this->design->assign('posts', $posts);
		
		// Метатеги
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}
		elseif(isset($keyword))
		{
			$this->design->assign('meta_title', $keyword);
		}
		
		// Last-Modified 
		$LastModified_unix = strtotime($this->settings->lastModifyPosts); // время последнего изменения страницы
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
		
		$body = $this->design->fetch('blog.tpl');
		
		return $body;
	}	
}
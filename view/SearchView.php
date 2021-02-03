<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон search.tpl
 *
 */

require_once('View.php');

class SearchView extends View
{
	
    // Отображение списка постов
	function fetch()
	{
        
        $filter = array(); 
        $filter['visible'] = 1;
        
        // Поиск
		$keyword = $this->request->get('keyword', 'string');
		if(!empty($keyword))
		{
			$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}	

		// Выбираем из базы
        $posts = $this->blog->get_posts($filter);
        $pages_search = $this->pages->get_pages($filter);
        $articles = $this->articles->get_articles($filter);
		
		// Передаем в шаблон
		$this->design->assign('posts', $posts);
        $this->design->assign('articles', $articles);
        $this->design->assign('pages_search', $pages_search);
		
		// Метатеги
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}
		
		$body = $this->design->fetch('search.tpl');
		
		return $body;
	}
	
}
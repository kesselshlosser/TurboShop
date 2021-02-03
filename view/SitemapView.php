<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон sitemap.tpl
 *
 */
require_once('View.php');

class SitemapView extends View
{
    function fetch()
    {
        
        $pages = $this->pages->get_pages();
        $this->design->assign('pages', $pages);
        
        $posts = $this->blog->get_posts(array('visible'=>1));
        $this->design->assign('posts', $posts);
       
        $categories = $this->categories->get_categories_tree();
        $categories = $this->cat_tree($categories);
        $this->design->assign('cats', $categories);
		
		$articles_categories = $this->articles_categories->get_articles_categories_tree();
        $articles_categories = $this->articles_cat_tree($articles_categories);
        $this->design->assign('articles_cats', $articles_categories);

		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->design->assign('page', $this->page);
		}        
        
        return $this->design->fetch('sitemap.tpl');
    }
    
    private function cat_tree($categories) {

        foreach($categories AS $k=>$v) {
            if(isset($v->subcategories)) $this->cat_tree($v->subcategories);
            $categories[$k]->products = $this->products->get_products(array('category_id' => $v->id));  
        } 
        
        return $categories;
    }
	
	private function articles_cat_tree($articles_categories) {

        foreach($articles_categories AS $k=>$v) {
            if(isset($v->subcategories)) $this->cat_tree($v->subcategories);
            $articles_categories[$k]->articles = $this->articles->get_articles(array('category_id' => $v->id));  
        } 
        
        return $articles_categories;
    }
}
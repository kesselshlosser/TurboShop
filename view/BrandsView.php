<?php

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон brands.tpl
 *
 */

require_once('View.php');

class BrandsView extends View {
    
    public function fetch() {
        $brands = $this->brands->get_brands();
        $this->design->assign('brands', $brands);
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
		
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
		
        return $this->design->fetch('brands.tpl');
    }
    
}

<?php
	
/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон wishlist.tpl
 *
 */

require_once('View.php');

class WishlistView extends View
{
	public $max_visited_products = 100; // Максимальное число хранимых товаров в истории
	
   /**
	*
	* Конструктор
	*
	*/	
	public function fetch()
	{
		$max_visited_products = 100;
		$expire = time()+60*60*24*365; // Время жизни - 365 дней
		
		if($this->request->get('product_url', 'string'))
		{
			
			if(!empty($_COOKIE['wishlist_products']))
			{
				$wishlist_products = explode(',', $_COOKIE['wishlist_products']);
				// Удалим текущий товар, если он был
				if(($exists = array_search($this->request->get('product_url', 'string'), $wishlist_products)) !== false)
				unset($wishlist_products[$exists]);
			}
			// Добавим текущий товар
			$wishlist_products[] = $this->request->get('product_url', 'string');
			$cookie_val = implode(',', array_slice($wishlist_products, -$max_visited_products, $max_visited_products));
			setcookie("wishlist_products", $cookie_val, $expire, "/");    
			
			header('location: '.$this->config->root_url.'/'.$this->lang_link.'wishlist/');
		}
		
		if($this->request->get('remove_product_url', 'string'))
		{
			if($this->request->get('remove_product_url', 'string')=='all')
			{
				setcookie("wishlist_products","", $expire, "/"); 
				header('location: '.$this->config->root_url.'/'.$this->lang_link.'wishlist/');
			}
			else
			{
				if(!empty($_COOKIE['wishlist_products']))
				{
					$wishlist_products = explode(',', $_COOKIE['wishlist_products']);
					// Удалим текущий товар, если он был
					if(($exists = array_search($this->request->get('remove_product_url', 'string'), $wishlist_products)) !== false)
					unset($wishlist_products[$exists]);
				}
				
				$cookie_val = implode(',', array_slice($wishlist_products, -$max_visited_products, $max_visited_products));
				setcookie("wishlist_products", $cookie_val, $expire, "/");    
				
				header('location: '.$this->config->root_url.'/'.$this->lang_link.'wishlist/');
			}
		}
		
	   /**
		*
		* Отображение отдельного товара
		*
		*/	
		if(!empty($_COOKIE['wishlist_products']))
		{
			$wishlist_products = explode(',', $_COOKIE['wishlist_products']);
			// Выбираем товары из базы
			foreach($wishlist_products as $product_url)
			{
				$pr = $this->products->get_product((string)$product_url);
				if(!empty($pr))
				$products[] =  $pr;
				else
				if(($exists = array_search((string)$product_url, $wishlist_products)) !== false)
				unset($wishlist_products[$exists]);
			}
		}
		//print_r($products);
		if(isset($products)&& !empty($products)){
			foreach($products as $k=>$product)
			{
				$product->images = $this->products->get_images(array('product_id'=>$product->id));
				$product->image = &$product->images[0];
				
				$cats = $this->categories->get_categories(array('product_id'=>$product->id));
				$product->cats = $cats;		
				
				$variants = $this->variants->get_variants(array('product_id'=>$product->id, 'in_stock'=>true));		
				// Скидка
				$discount = 0;
				if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id'])))
				$discount = $user->discount;
				$product->variants = $variants;
				
				// Вариант по умолчанию
				if(($v_id = $this->request->get('variant', 'integer'))>0 && isset($variants[$v_id]))
				$product->variant = $variants[$v_id];
				else
				$product->variant = reset($variants);
			}
			// И передаем его в шаблон
			$this->design->assign('products', $products);   
		}
		else
		{
			unset($_COOKIE['wishlist_products']);
			unset($wishlist_products);
		}
		
		$this->design->assign('wishlist', true);				
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}	
		
		return $this->design->fetch('wishlist.tpl');
	}
}	
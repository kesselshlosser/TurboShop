<?PHP
	
/**
* Turbo CMS
*
* @author	Turbo CMS
* @link	https://turbo-cms.com/
*
* Этот класс использует шаблон compare.tpl
*
*/

require_once('View.php');

class CompareView extends View
{
	public $max_products = 4;
	
	/**
		*
		* Конструктор
		*
	*/	
	public function fetch()
	{
		
		if($this->request->get('product_url', 'string'))
		{
			$_SESSION['compared_products'][$this->request->get('product_url', 'string')] = $this->request->get('product_url', 'string');
			header('location: '.$this->config->root_url.'/compare/');
		}
		if(isset($_SESSION['compared_products'])){
			if(count($_SESSION['compared_products'])>$this->max_products)
			array_shift($_SESSION['compared_products']);
		}
		if($this->request->get('remove_product_url', 'string'))
		{
			if($this->request->get('remove_product_url', 'string')=='all')
			unset($_SESSION['compared_products']);
			else
			unset($_SESSION['compared_products'][$this->request->get('remove_product_url', 'string')]);
			
			header('location: '.$this->config->root_url.'/'.$this->lang_link.'compare/');
		}
		
		/**
			*
			* Отображение отдельного товара
			*
		*/	
		
		if(isset($_SESSION['compared_products'])){
			// Выбираем товары из базы
			foreach($_SESSION['compared_products'] as $product_url)
			{
				$products[] =  $this->products->get_product((string)$product_url);
			}
		}
		
		if(isset($products)){
			foreach($products as $k=>$product)
			{
				@$product->images = $this->products->get_images(array('product_id'=>$product->id));
				$product->image = &$product->images[0];
				
				@$cats = $this->categories->get_categories(array('product_id'=>$product->id));
				$product->cats = $cats;		
				
				@$variants = $this->variants->get_variants(array('product_id'=>$product->id, 'in_stock'=>true));		
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
				
				@$product->features = $this->features->get_product_options(array('product_id'=>$product->id));
				foreach($product->features as $k=>$feature)
				{
					$_SESSION['compare_features'][$feature->feature_id]	=	$feature->feature_id;
				} 
				
			}
		}
		if(isset($_SESSION['compare_features'])){
			// Выбираем товары из базы
			foreach($_SESSION['compare_features'] as $feature_id)
			{
				$compare_features[] =  $this->features->get_compare($feature_id);
			}
			$this->design->assign('compare_features', $compare_features);
		}
		unset($_SESSION['compare_features']);		
		// И передаем его в шаблон
		if(isset($products))
		{
			$this->design->assign('products', $products);
		}	
		
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}	
		return $this->design->fetch('compare.tpl');
	}
	
}	
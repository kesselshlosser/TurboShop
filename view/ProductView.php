<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон product.tpl
 *
 */

require_once('View.php');


class ProductView extends View
{

	function fetch()
	{   
		$product_url = $this->request->get('product_url', 'string');
		
		if(empty($product_url))
			return false;

		// Выбираем товар из базы
		$product = $this->products->get_product((string)$product_url);
		if(empty($product) || (!$product->visible && empty($_SESSION['admin'])))
			return false;
		
		// Last-Modified
		$LastModified_unix = strtotime($product->last_modified); // время последнего изменения страницы
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
		
		$product->images = $this->products->get_images(array('product_id'=>$product->id));
		$product->image = &$product->images[0];

		$variants = array();
		$colors = array();    
		$image_ids = array();    
		foreach($this->variants->get_variants(array('product_id'=>$product->id, 'in_stock'=>true)) as $v) {
			$variants[$v->id] = $v;
			$colors[$v->color]['id'] = $v->id;
			$colors[$v->color]['code'] = $v->color_code;
			$image_ids[$v->color] = $v->images_ids; 
		}
		
		$product->variants = $variants;
		$product->colors = $colors;
		$product->image_ids = $image_ids;
		
		// Вариант по умолчанию
		if(($v_id = $this->request->get('variant', 'integer'))>0 && isset($variants[$v_id]))
			$product->variant = $variants[$v_id];
		else
			$product->variant = reset($variants);
					
		$product->features = $this->features->get_product_options(array('product_id'=>$product->id));
		
		$temp_options = array();
    	foreach($product->features as $option) {
        	if(empty($temp_options[$option->feature_id]))
			$temp_options[$option->feature_id] = new stdClass;         	 
				$temp_options[$option->feature_id]->feature_id = $option->feature_id;
				$temp_options[$option->feature_id]->name = $option->name;
				$temp_options[$option->feature_id]->translit = $option->translit;
				$temp_options[$option->feature_id]->values[] = $option->value;   
			}
          	 
    	foreach($temp_options as $id => $option)
       	$temp_options[$id]->value = implode(', ', $temp_options[$id]->values);   	 
              	 
    	$product->features = $temp_options;
		
		if(!empty($product->features)){
            foreach($product->features as &$f){
                $feature = $this->features->get_feature(intval($f->feature_id));
                    $f->is_color = $feature->is_color;
					$f->in_filter = $feature->in_filter;
					$f->url_in_product = $feature->url_in_product;
					$f->url = $feature->url;
            }
        }
	
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
			
			// Передадим комментарий обратно в шаблон - при ошибке нужно будет заполнить форму
			$this->design->assign('comment_text', $comment->text);
			$this->design->assign('comment_name', $comment->name);
			
			// Проверяем капчу и заполнение формы
			if ($this->settings->captcha_product && ($_SESSION['captcha_product'] != $captcha_code || empty($captcha_code)))
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
				$comment->object_id = $product->id;
				$comment->type      = 'product';
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
				
		// Связанные товары
		$related_ids = array();
		$related_products = array();
		foreach($this->products->get_related_products($product->id) as $p)
		{
			$related_ids[] = $p->related_id;
			$related_products[$p->related_id] = null;
		}
		if(!empty($related_ids))
		{
			foreach($this->products->get_products(array('id'=>$related_ids, 'in_stock'=>1, 'visible'=>1)) as $p)
				$related_products[$p->id] = $p;
			
			$related_products_images = $this->products->get_images(array('product_id'=>array_keys($related_products)));
			foreach($related_products_images as $related_product_image)
				if(isset($related_products[$related_product_image->product_id]))
					$related_products[$related_product_image->product_id]->images[] = $related_product_image;
			$related_products_variants = $this->variants->get_variants(array('product_id'=>array_keys($related_products), 'in_stock'=>1));
			foreach($related_products_variants as $related_product_variant)
			{
				if(isset($related_products[$related_product_variant->product_id]))
				{
					$related_products[$related_product_variant->product_id]->variants[] = $related_product_variant;
				}
			}
			foreach($related_products as $id=>$r)
			{
				if(is_object($r))
				{
					$r->image = &$r->images[0];
					$r->variant = &$r->variants[0];
				}
				else
				{
					unset($related_products[$id]);
				}
			}
			$this->design->assign('related_products', $related_products);
		}

		// Отзывы о товаре
		$comments = $this->comments->get_comments(array('type'=>'product', 'object_id'=>$product->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR']));
		
		// Файлы
		$files = $this->files->get_files(array('object_id'=>$product->id,'type'=>'product'));
		$this->design->assign('cms_files', $files);  
		
		// Видео
		$product->videos = $this->products->get_videos(array('product_id'=>$product->id));
		
		// Соседние товары
		$this->design->assign('next_product', $this->products->get_next_product($product->id));
		$this->design->assign('prev_product', $this->products->get_prev_product($product->id));
        
        // Акционный товар таймер
        if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
            $product->sale_to = null;                    
            if (isset($product->variant) && isset($product->variant->compare_price)) {
                $product->variant->price = $product->variant->compare_price;
                $product->variant->compare_price = 0;
                $v = new stdClass();
                $v->price = $product->variant->price;
                $v->compare_price = 0;
                $this->variants->update_variant($product->variant->id, $v);
            }
        }

		// И передаем его в шаблон
		$this->design->assign('product', $product);
		$this->design->assign('comments', $comments);
		
		// Категория и бренд товара
		$product->categories = $this->categories->get_categories(array('product_id'=>$product->id));
		$this->design->assign('brand', $this->brands->get_brand(intval($product->brand_id)));		
		$this->design->assign('category', reset($product->categories));		
		
		// Добавление в историю просмотров товаров
		$max_visited_products = 100; // Максимальное число хранимых товаров в истории
		$expire = time()+60*60*24*30; // Время жизни - 30 дней
		if(!empty($_COOKIE['browsed_products']))
		{
			$browsed_products = explode(',', $_COOKIE['browsed_products']);
			// Удалим текущий товар, если он был
			if(($exists = array_search($product->id, $browsed_products)) !== false)
				unset($browsed_products[$exists]);
		}
		// Добавим текущий товар
		$browsed_products[] = $product->id;
		$cookie_val = implode(',', array_slice($browsed_products, -$max_visited_products, $max_visited_products));
		setcookie("browsed_products", $cookie_val, $expire, "/");
		
		$this->design->assign('meta_title', $product->meta_title);
		$this->design->assign('meta_keywords', $product->meta_keywords);
		$this->design->assign('meta_description', $product->meta_description);
        
        $category = reset($product->categories);
        if($product->brand_id)
            $brand = $this->brands->get_brand(intval($product->brand_id));

        $auto_meta = new StdClass;

        $auto_meta->title       = $this->seo->product_meta_title       ? $this->seo->product_meta_title       : '';
        $auto_meta->keywords    = $this->seo->product_meta_keywords    ? $this->seo->product_meta_keywords    : '';
        $auto_meta->description = $this->seo->product_meta_description ? $this->seo->product_meta_description : '';
        
        $auto_meta_parts = @array(
                                '{product}' => ($product ? $product->name : ''),
                                '{category}' => ($category ? $category->name : ''),
                                '{brand}' => ($brand ? $brand->name : ''),
                                '{page}' => ($page ? $page->header : ''),
                                '{price}' => (($product->variant && $product->variant->price != null) ? $this->money->convert($product->variant->price).' '.$this->currency->sign : ''),
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
		
		return $this->design->fetch('product.tpl');
	}
}
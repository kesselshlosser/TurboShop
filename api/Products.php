<?php

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 */

require_once('Turbo.php');

class Products extends Turbo
{
	
	/**
	* Функция возвращает товары
	* Возможные значения фильтра:
	* id - id товара или их массив
	* category_id - id категории или их массив
	* brand_id - id бренда или их массив
	* page - текущая страница, integer
	* limit - количество товаров на странице, integer
	* sort - порядок товаров, возможные значения: position(по умолчанию), name, price
	* keyword - ключевое слово для поиска
	* features - фильтр по свойствам товара, массив (id свойства => значение свойства)
	*/
	public function get_products($filter = array())
	{		
		// По умолчанию
		$page = 1;
		$category_id_filter = '';
		$brand_id_filter = '';
		$product_id_filter = '';
		$features_filter = '';
		$is_new_filter = '';
        $is_hit_filter = '';
		$keyword_filter = '';
		$visible_filter = '';
		$is_featured_filter = '';
        $is_export_filter = '';
		$discounted_filter = '';
		$in_stock_filter = '';
		$group_by = '';
		$order = 'p.position DESC';
		$variant_filter = '';
		$color_filter = '';
		$variant_join = '';
        $prices = '';
		$sql_limit = '';
        
        $lang_id  = $this->languages->lang_id();
        if($lang_id)
        {
            $px = 'l';
        }
        else{
            $px = 'p';
        }

		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		if(isset($limit) && isset($page))
			$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		if(!empty($filter['id']))
			$product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);

		if(!empty($filter['category_id']))
		{
			$category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
			$group_by = "GROUP BY p.id";
		}

		if(!empty($filter['brand_id']))
			$brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);

		if(isset($filter['featured']))
			$is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));
		
		if(!empty($filter['is_new']))
    		$is_new_filter = $this->db->placehold('AND p.is_new=?', intval($filter['is_new']));

    	if(!empty($filter['is_hit']))
    		$is_hit_filter = $this->db->placehold('AND p.is_hit=?', intval($filter['is_hit']));
        
        if(isset($filter['to_export']))
			$is_export_filter = $this->db->placehold('AND p.to_export=?', intval($filter['to_export']));

		if(isset($filter['discounted']))
			$discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));

		if(isset($filter['in_stock']))
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));

 		if(!empty($filter['sort']))
			switch ($filter['sort'])
			{
				case 'position':
				$order = 'p.position DESC';
				break;
		   
				// по имени от А до Я
				case 'name':
				$order = 'p.name';
				break;
		   
				// по имени от Я до А
				case 'name_desc':
				$order = 'p.name DESC';
				break;
		   
				// по цене Низкие > Высокие
				case 'price':
				$order = '(SELECT pv.price FROM __variants pv WHERE (pv.stock IS NULL OR pv.stock>0) AND p.id = pv.product_id AND pv.position=(SELECT MIN(position) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1) LIMIT 1)';
				break;
		   
				// по цене Высокие < Низкие
				case 'price_desc':
				$order = '(SELECT pv.price FROM __variants pv WHERE (pv.stock IS NULL OR pv.stock>0) AND p.id = pv.product_id AND pv.position=(SELECT MIN(position) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1) LIMIT 1) DESC';
				break;
		   
				case 'created':
				$order = 'p.created DESC';
				break;
				
				case 'random':
				$order = 'RAND()';
				break;
				
				case 'rating':
				$order = 'p.rating DESC, p.position DESC';
				break;
		   
			}
        
		if(isset($filter['variants']))
        {
            $variant_filter = $this->db->placehold(' AND pv.name in(?@)', (array)$filter['variants']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }
            
        if(isset($filter['colors']))
        {
            $color_filter = $this->db->placehold(' AND pv.color in(?@)', (array)$filter['colors']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }	
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				if($kw!=='')
					$keyword_filter .= $this->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%'))");
			}
		}

		if(!empty($filter['features']) && !empty($filter['features']))
            foreach($filter['features'] as $feature=>$value)
                $features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND translit in(?@) ) ', $feature, (array)$value);
                
        if(!empty($filter['min_price']) && !empty($filter['max_price']))
			$prices = $this->db->placehold('AND p.id in(SELECT v.product_id FROM __variants v WHERE v.price >= ? AND v.price <= ? AND v.product_id = p.id)', intval($filter['min_price']), intval($filter['max_price']));
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
		
		$query = "SELECT  
					p.id,
					p.url,
					p.brand_id,
					p.name,
					p.annotation,
					p.body,
					p.position,
                    p.sale_to,
					p.created as created,
					p.visible, 
                    p.to_export,
					p.featured,
					p.is_new, 
                    p.is_hit, 
                    p.rating,
					p.votes,
					p.meta_title, 
					p.meta_keywords, 
					p.meta_description, 
					b.name as brand,
					b.url as brand_url,
                    ".$lang_sql->fields."
				FROM __products p
                 ".$lang_sql->join."
				$category_id_filter 
				LEFT JOIN __brands b ON p.brand_id = b.id
				WHERE 
					1
					$product_id_filter
					$brand_id_filter
					$features_filter
					$keyword_filter
					$variant_filter
					$color_filter
					$is_featured_filter
					$is_new_filter
                    $is_hit_filter
                    $is_export_filter
					$discounted_filter
					$in_stock_filter
					$visible_filter
                    $prices
				$group_by
				ORDER BY $order
					$sql_limit";

		$this->db->query($query);

		return $this->db->results();
	}

	/**
	* Функция возвращает количество товаров
	* Возможные значения фильтра:
	* category_id - id категории или их массив
	* brand_id - id бренда или их массив
	* keyword - ключевое слово для поиска
	* features - фильтр по свойствам товара, массив (id свойства => значение свойства)
	*/
	public function count_products($filter = array())
	{		
		$category_id_filter = '';
		$brand_id_filter = '';
		$product_id_filter = '';
		$keyword_filter = '';
		$visible_filter = '';
		$is_featured_filter = '';
		$is_new_filter = '';
		$is_hit_filter = '';
        $is_export_filter = '';
		$in_stock_filter = '';
		$discounted_filter = '';
		$features_filter = '';
		$variant_filter = '';
		$color_filter = '';
		$variant_join = '';
        $prices = '';
        
        $lang_id  = $this->languages->lang_id();
        if($lang_id)
        {
            $px = 'l';
        }
        else{
            $px = 'p';
        }
		
		if(!empty($filter['category_id']))
			$category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);

		if(!empty($filter['brand_id']))
			$brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);

		if(!empty($filter['id']))
			$product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);
		
		if(isset($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				if($kw!=='')
					$keyword_filter .= $this->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%'))");
			}
		}
		
		if(isset($filter['variants']))
        {
            $variant_filter = $this->db->placehold(' AND pv.name in(?@)', (array)$filter['variants']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }
            
        if(isset($filter['colors']))
        {
            $color_filter = $this->db->placehold(' AND pv.color in(?@)', (array)$filter['colors']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

		if(isset($filter['featured']))
			$is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));
		
		if(!empty($filter['is_new']))
    		$is_new_filter = $this->db->placehold('AND p.is_new=?', intval($filter['is_new']));

    	if(!empty($filter['is_hit']))
    		$is_hit_filter = $this->db->placehold('AND p.is_hit=?', intval($filter['is_hit']));
        
        if(!empty($filter['to_export']))
			$is_export_filter = $this->db->placehold('AND p.to_export=?', intval($filter['to_export']));

		if(isset($filter['in_stock']))
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));

		if(isset($filter['discounted']))
			$discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
		
		if(!empty($filter['features']) && !empty($filter['features']))
            foreach($filter['features'] as $feature=>$value)
                $features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND translit in(?@) ) ', $feature, (array)$value);
        
        if(!empty($filter['min_price']) && !empty($filter['max_price']))
			$prices = $this->db->placehold('AND p.id in(SELECT v.product_id FROM __variants v WHERE v.price >= ? AND v.price <= ? AND v.product_id = p.id)', intval($filter['min_price']), intval($filter['max_price']));
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
		
		$query = "SELECT count(distinct p.id) as count
				FROM __products AS p
                ".$lang_sql->join."
				$category_id_filter
				WHERE 1
					$brand_id_filter
					$product_id_filter
					$keyword_filter
					$variant_filter
					$color_filter
					$is_featured_filter
					$is_new_filter
					$is_hit_filter
                    $is_export_filter
					$in_stock_filter
					$discounted_filter
					$visible_filter
                    $prices
					$features_filter ";

		$this->db->query($query);	
		return $this->db->result('count');
	}

	/**
	* Функция возвращает товар по id
	* @param	$id
	* @retval	object
	*/
	public function get_product($id)
	{
		if(is_int($id))
			$filter = $this->db->placehold('p.id = ?', $id);
		else
			$filter = $this->db->placehold('p.url = ?', $id);
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
			
		$query = "SELECT DISTINCT
					p.id,
					p.url,
					p.brand_id,
					p.name,
					p.annotation,
					p.body,
					p.position,
                    p.sale_to,
					p.created as created,
					p.visible, 
                    p.to_export,
					p.featured,
					p.is_new,
					p.is_hit,
                    p.rating,
					p.votes,
					p.meta_title, 
					p.meta_keywords, 
					p.meta_description,
                    p.last_modified,
                    ".$lang_sql->fields."
				FROM __products AS p
                ".$lang_sql->join."
                WHERE $filter
                GROUP BY p.id
                LIMIT 1";
		$this->db->query($query);
		$product = $this->db->result();
		return $product;
	}

    public function update_product($id, $product)
	{
	    $product = (object)$product;
	    $result = $this->languages->get_description($product, 'product');
        if(!empty($result->data))$product = $result->data;

		$query = $this->db->placehold("UPDATE __products SET `last_modified`=NOW(), ?% WHERE id in (?@) LIMIT ?", $product, (array)$id, count((array)$id));
		if($this->db->query($query))
        {
            if(!empty($result->description)){
                $this->languages->action_description($id, $result->description, 'product', $this->languages->lang_id());
            }
			return $id;
        }
		else
			return false;
	}
	
    public function add_product($product)
	{	
		$product = (array) $product;
		
		if(empty($product['url']))
		{
			$product['url'] = preg_replace("/[\s]+/ui", '-', $product['name']);
			$product['url'] = strtolower(preg_replace("/[^0-9a-zа-я\-]+/ui", '', $product['url']));
		}

		// Если есть товар с таким URL, добавляем к нему число
		while($this->get_product((string)$product['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $product['url'], $parts))
				$product['url'] = $parts[1].'_'.($parts[2]+1);
			else
				$product['url'] = $product['url'].'_2';
		}

        $product = (object)$product;
	    $result = $this->languages->get_description($product, 'product');
        if(!empty($result->data))$product = $result->data;

		if($this->db->query("INSERT INTO __products SET ?%", $product))
		{
			$id = $this->db->insert_id();
			$this->db->query("UPDATE __products SET `last_modified`=NOW(), position=id WHERE id=?", $id);

            if(!empty($result->description)){
                $this->languages->action_description($id, $result->description, 'product');
            }
			return $id;
		}
		else
			return false;
	}
	
	/*
	*
	* Удалить товар
	*
	*/	
	public function delete_product($id)
	{
		if(!empty($id))
		{
			// Удаляем варианты
			$variants = $this->variants->get_variants(array('product_id'=>$id));
			foreach($variants as $v)
				$this->variants->delete_variant($v->id);
			
			// Удаляем изображения
			$images = $this->get_images(array('product_id'=>$id));
			foreach($images as $i)
				$this->delete_image($i->id);
				
			// Удаляем видео
			$query = $this->db->placehold('DELETE FROM __products_videos WHERE product_id=?', $id);
			$this->db->query($query);		
			
			// Удаляем категории
			$categories = $this->categories->get_categories(array('product_id'=>$id));
			foreach($categories as $c)
				$this->categories->delete_product_category($id, $c->id);

			// Удаляем свойства
			$options = $this->features->get_options(array('product_id'=>$id));
			foreach($options as $o)
				$this->features->delete_option($id, $o->feature_id);
			
			// Удаляем связанные товары
			$related = $this->get_related_products($id);
			foreach($related as $r)
				$this->delete_related_product($id, $r->related_id);
			
			// Удаляем товар из связанных с другими
			$query = $this->db->placehold("DELETE FROM __related_products WHERE related_id=?", intval($id));
			$this->db->query($query);
			
			// Удаляем отзывы
			$comments = $this->comments->get_comments(array('object_id'=>$id, 'type'=>'product'));
			foreach($comments as $c)
				$this->comments->delete_comment($c->id);
			
			// Удаляем из покупок
			$this->db->query('UPDATE __purchases SET product_id=NULL WHERE product_id=?', intval($id));
            
            // Удаляем языки
			$query = $this->db->placehold("DELETE FROM __lang_products WHERE product_id=?", intval($id));
			$this->db->query($query);
			
			// Удаляем товар
			$query = $this->db->placehold("DELETE FROM __products WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;			
		}
		return false;
	}	
	
	public function duplicate_product($id)
	{
    	$product = $this->get_product($id);
    	$product->id = null;
    	$product->external_id = '';
    	$product->created = null;

		// Сдвигаем товары вперед и вставляем копию на соседнюю позицию
    	$this->db->query('UPDATE __products SET position=position+1 WHERE position>?', $product->position);
    	$new_id = $this->products->add_product($product);
    	$this->db->query('UPDATE __products SET position=? WHERE id=?', $product->position+1, $new_id);
    	
    	// Очищаем url
    	$this->db->query('UPDATE __products SET url="" WHERE id=?', $new_id);
    	
		// Дублируем категории
		$categories = $this->categories->get_product_categories($id);
		foreach($categories as $c)
			$this->categories->add_product_category($new_id, $c->category_id);
    	
    	// Дублируем изображения
    	$images = $this->get_images(array('product_id'=>$id));
    	foreach($images as $image)
    		$this->add_image($new_id, $image->filename);
			
		// Дублируем видео
		$videos = $this->get_videos(array('product_id'=>$id));
    	foreach($videos as $video)
    		$this->add_product_video($new_id, $video->link);	
    		
    	// Дублируем варианты
    	$variants = $this->variants->get_variants(array('product_id'=>$id));
    	foreach($variants as $variant)
    	{
    		$variant->product_id = $new_id;
    		unset($variant->id);
    		if($variant->infinity)
    			$variant->stock = null;
    		unset($variant->infinity);
    		$variant->external_id = '';
    		$this->variants->add_variant($variant);
    	}
    	
    	// Дублируем свойства
		$options = $this->features->get_options(array('product_id'=>$id));
		foreach($options as $o)
			$this->features->update_option($new_id, $o->feature_id, $o->value);
			
		// Дублируем связанные товары
		$related = $this->get_related_products($id);
		foreach($related as $r)
			$this->add_related_product($new_id, $r->related_id);
			
    	$this->multi_duplicate_product($id, $new_id);	
    	return $new_id;
	}

	public function get_related_products($product_id = array())
	{
		if(empty($product_id))
			return array();

		$product_id_filter = $this->db->placehold('AND product_id in(?@)', (array)$product_id);
				
		$query = $this->db->placehold("SELECT product_id, related_id, position
					FROM __related_products
					WHERE 
					1
					$product_id_filter   
					ORDER BY position       
					");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	// Функция возвращает связанные товары
	public function add_related_product($product_id, $related_id, $position=0)
	{
		$query = $this->db->placehold("INSERT IGNORE INTO __related_products SET product_id=?, related_id=?, position=?", $product_id, $related_id, $position);
		$this->db->query($query);
		return $related_id;
	}
	
	// Удаление связанного товара
	public function delete_related_product($product_id, $related_id)
	{
		$query = $this->db->placehold("DELETE FROM __related_products WHERE product_id=? AND related_id=? LIMIT 1", intval($product_id), intval($related_id));
		$this->db->query($query);
	}
	
	function get_images($filter = array())
	{		
		$product_id_filter = '';
		$group_by = '';

		if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND i.product_id in(?@)', (array)$filter['product_id']);

		// images
		$query = $this->db->placehold("SELECT i.id, i.product_id, i.name, i.filename, i.position
									FROM __images AS i WHERE 1 $product_id_filter $group_by ORDER BY i.product_id, i.position");
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function add_image($product_id, $filename, $name = '')
	{
		$query = $this->db->placehold("SELECT id FROM __images WHERE product_id=? AND filename=?", $product_id, $filename);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __images SET product_id=?, filename=?", $product_id, $filename);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __images SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	public function update_image($id, $image)
	{
	
		$query = $this->db->placehold("UPDATE __images SET ?% WHERE id=?", $image, $id);
		$this->db->query($query);
		
		return($id);
	}
	
	public function delete_image($id)
	{
		$query = $this->db->placehold("SELECT filename FROM __images WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('filename');
		$query = $this->db->placehold("DELETE FROM __images WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		$query = $this->db->placehold("SELECT count(*) as count FROM __images WHERE filename=? LIMIT 1", $filename);
		$this->db->query($query);
		$count = $this->db->result('count');
		if($count == 0)
		{			
			$file = pathinfo($filename, PATHINFO_FILENAME);
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			$webp = 'webp';
			
			// Удалить все ресайзы
			$rezised_images = glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$ext);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$ext) as $f)
				@unlink($f);
				
			$rezised_images = glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$webp);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$webp) as $f)
				@unlink($f);	

			@unlink($this->config->root_dir.$this->config->original_images_dir.$filename);		
		}
	}
		
	/*
	*
	* Следующий товар
	*
	*/	
	public function get_next_product($id)
	{
		$this->db->query("SELECT position FROM __products WHERE id=? LIMIT 1", $id);
		$position = $this->db->result('position');
		
		$this->db->query("SELECT pc.category_id FROM __products_categories pc WHERE product_id=? ORDER BY position LIMIT 1", $id);
		$category_id = $this->db->result('category_id');

		$query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
										WHERE pc.product_id=p.id AND p.position>? 
										AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
										AND pc.category_id=? 
										AND p.visible ORDER BY p.position limit 1", $position, $category_id);
		$this->db->query($query);
 
		return $this->get_product((integer)$this->db->result('id'));
	}
	
	/*
	*
	* Предыдущий товар
	*
	*/	
	public function get_prev_product($id)
	{
		$this->db->query("SELECT position FROM __products WHERE id=? LIMIT 1", $id);
		$position = $this->db->result('position');
		
		$this->db->query("SELECT pc.category_id FROM __products_categories pc WHERE product_id=? ORDER BY position LIMIT 1", $id);
		$category_id = $this->db->result('category_id');

		$query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
										WHERE pc.product_id=p.id AND p.position<? 
										AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
										AND pc.category_id=? 
										AND p.visible ORDER BY p.position DESC limit 1", $position, $category_id);
		$this->db->query($query);
 
		return $this->get_product((integer)$this->db->result('id'));	
	}
	
	function get_videos($filter = array())
	{		
		$product_id_filter = '';
		$group_by = '';
		$videos = array();

		if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND product_id in(?@)', (array)$filter['product_id']);

		// images
		$query = $this->db->placehold("SELECT *
									FROM __products_videos WHERE 1 $product_id_filter $group_by ORDER BY product_id, position");
		$this->db->query($query);
		$results = $this->db->results();
		foreach($results as &$v){
			preg_match('~v=([A-Za-z0-9_-]+)~', $v->link, $match); 
            $v->vid = $match[1];
			$videos[] = $v;
		}
		return $videos;
		
	}
	
	public function add_product_video($product_id, $link, $position=0)
	{
		$query = $this->db->placehold("SELECT id FROM __products_videos WHERE product_id=? AND link=?", $product_id, $link);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __products_videos SET product_id=?, link=?", $product_id, $link);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __products_videos SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	public function multi_duplicate_product($id, $new_id) {
        $lang_id = $this->languages->lang_id();
        if (!empty($lang_id)) {
            $languages = $this->languages->get_languages();
            $prd_fields = $this->languages->get_fields('products');
            $variant_fields = $this->languages->get_fields('variants');
            foreach ($languages as $language) {
                if ($language->id != $lang_id) {
                    $this->languages->set_lang_id($language->id);
                    //Product
                    if (!empty($prd_fields)) {
                        $old_prd = $this->get_product($id);
                        $upd_prd = new stdClass();
                        foreach($prd_fields as $field) {
                            $upd_prd->{$field} = $old_prd->{$field};
                        }
                        $this->update_product($new_id, $upd_prd);
                    }
                    
                    // Дублируем варианты
                    if (!empty($variant_fields)) {
                        $variants = $this->variants->get_variants(array('product_id'=>$new_id));
                        $old_variants = $this->variants->get_variants(array('product_id'=>$id));
                        foreach($old_variants as $i=>$old_variant) {
                            $upd_variant = new stdClass();
                            foreach ($variant_fields as $field) {
                                $upd_variant->{$field} = $old_variant->{$field};
                            }
                            $this->variants->update_variant($variants[$i]->id, $upd_variant);
                        }
                    }
            		
                    // Дублируем свойства
                    $options = $this->features->get_options(array('product_id'=>$id));
                    foreach($options as $o) {
                        $this->features->update_option($new_id, $o->feature_id, $o->value);
                    }
                    
                    $this->languages->set_lang_id($lang_id);
                }
            }
        }
    }
	
}
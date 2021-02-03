<?php

/**
 * Работа с вариантами товаров
 *
 * @author		Turbo CMS
 * @link		https://turbo-cms.com
 *
 */

require_once('Turbo.php');

class Variants extends Turbo
{
		public function get_value_variants($filter = array())
		{        
			$product_id_filter = '';
			$instock_filter = '';
			$group = '';
			$an = '';
			
			if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND product_id in(?@)', (array)$filter['product_id']);
        
			if(!empty($filter['in_stock']) && $filter['in_stock'])
			$instock_filter = $this->db->placehold('AND (stock>0 OR stock IS NULL)');
			
            if(!empty($filter['type']) && $filter['type'] == 'name')
			{$group = $this->db->placehold('GROUP BY name');
			$an = "AND name <> ''";} 
			
            elseif(!empty($filter['type']) && $filter['type'] == 'color')
			{$group = $this->db->placehold('GROUP BY color');
			$an = "AND color <> ''";}           
			
            if(!$product_id_filter)
			return array();
            
			
			$query = $this->db->placehold("SELECT name, color, color_code
			FROM __variants
			WHERE 1
			$an
			$product_id_filter                  
			$instock_filter
			$group                
			");
			$this->db->query($query);    
			return $this->db->results();
		} 
		
		/**
			* Функция возвращает варианты товара
			* @param	$filter
			* @retval	array
		*/
		public function get_variants($filter = array())
		{		
			$product_id_filter = '';
			$variant_id_filter = '';
			$instock_filter = '';
			
			if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND v.product_id in(?@)', (array)$filter['product_id']);
			
			if(!empty($filter['id']))
			$variant_id_filter = $this->db->placehold('AND v.id in(?@)', (array)$filter['id']);
			
			if(!empty($filter['in_stock']) && $filter['in_stock'])
			$instock_filter = $this->db->placehold('AND (v.stock>0 OR v.stock IS NULL)');
			
			if(!$product_id_filter && !$variant_id_filter)
			return array();
            
            $lang_sql = $this->languages->get_query(array('object'=>'variant'));
					
            $query = $this->db->placehold("SELECT v.id, v.product_id , v.price, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.name, v.color, v.color_code, v.images_ids, v.weight, v.position, ".$lang_sql->fields."
				FROM __variants AS v
                ".$lang_sql->join."
				WHERE 
				1
				$product_id_filter          
				$variant_id_filter  
				$instock_filter 
				ORDER BY v.position       
				", $this->settings->max_order_amount);
		
			$this->db->query($query);	
			return $this->db->results();
		}
		
		public function get_variant($id)
		{	
			if(empty($id))
			return false;
        
            $lang_sql = $this->languages->get_query(array('object'=>'variant'));
			
			$query = $this->db->placehold("SELECT v.id, v.product_id , v.price, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.name, v.color, v.color_code, v.images_ids, v.weight, ".$lang_sql->fields."
				FROM __variants v ".$lang_sql->join." WHERE v.id=?
				LIMIT 1", $this->settings->max_order_amount, $id);
			
			$this->db->query($query);	
			$variant = $this->db->result();
			return $variant;
		}

        public function update_variant($id, $variant)
        {
            $variant = (object)$variant;

            $result = $this->languages->get_description($variant, 'variant');
            if(!empty($result->data))$variant = $result->data;

            $query = $this->db->placehold("UPDATE __variants SET ?% WHERE id=? LIMIT 1", $variant, intval($id));
            $this->db->query($query);

            if(!empty($result->description)){
                $this->languages->action_description($id, $result->description, 'variant', $this->languages->lang_id());
            }

            return $id;
        }
		
		public function add_variant($variant)
        {
            $variant = (object)$variant;

            $result = $this->languages->get_description($variant, 'variant');
            if(!empty($result->data))$variant = $result->data;

            $query = $this->db->placehold("INSERT INTO __variants SET ?%", $variant);
            $this->db->query($query);
            $variant_id = $this->db->insert_id();

            if(!empty($result->description)){
              $this->languages->action_description($variant_id, $result->description, 'variant');
            }

            return $variant_id;
        }
		
		public function delete_variant($id)
		{
			if(!empty($id))
			{
				$query = $this->db->placehold("DELETE FROM __variants WHERE id = ? LIMIT 1", intval($id));
				$this->db->query($query);
				$this->db->query('UPDATE __purchases SET variant_id=NULL WHERE variant_id=?', intval($id));
                $this->db->query("DELETE FROM __lang_variants WHERE variant_id = ?", intval($id));
			}
		}
}	
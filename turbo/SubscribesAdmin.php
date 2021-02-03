<?PHP 
	
require_once('api/Turbo.php');

########################################
class SubscribesAdmin extends Turbo
{
	function fetch()
	{
		
		// Обработка действий 	
		if($this->request->method('post'))
		{
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(!empty($ids))
			switch($this->request->post('action'))
			{
				case 'delete':
				{
					foreach($ids as $id)
					$this->subscribes->delete_subscribe($id);    
					break;
				}
				case 'processed': 
				{
					foreach ($ids as $id) 
					$this->subscribes->update_subscribe($id, array('processed'=>1));
					break;
				}
			}		
			
		}
		
		// Отображение
		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
		$filter['limit'] = 40;
		
		$subscribes_count = $this->subscribes->count_subscribes($filter);
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
		$filter['limit'] = $subscribes_count;	
		
		$subscribes = $this->subscribes->get_subscribes($filter, true);
		
		$this->design->assign('pages_count', ceil($subscribes_count/$filter['limit']));
		$this->design->assign('current_page', $filter['page']);
		
		$this->design->assign('subscribes', $subscribes);
		$this->design->assign('subscribes_count', $subscribes_count);
		
		return $this->design->fetch('subscribes.tpl');
	}
}	
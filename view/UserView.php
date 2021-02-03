<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблоны user.tpl
 *
 */
 
require_once('View.php');

class UserView extends View
{
	function fetch()
	{
		if(empty($this->user))
		{
			header('Location: '.$this->config->root_url.'/user/login');
			exit();
		}
	
		if($this->request->method('post') && $this->request->post('name'))
		{
			$name			= $this->request->post('name');
			$email			= $this->request->post('email');
            $phone          = $this->request->post('phone');
            $address        = $this->request->post('address');
			$password		= $this->request->post('password');
			
			$this->design->assign('name', $name);
			$this->design->assign('email', $email);
            $this->design->assign('phone', $user->phone);
            $this->design->assign('address', $user->address);
			
			$this->db->query('SELECT count(*) as count FROM __users WHERE email=? AND id!=?', $email, $this->user->id);
			$user_exists = $this->db->result('count');

			if($user_exists)
				$this->design->assign('error', 'user_exists');
			elseif(empty($name))
				$this->design->assign('error', 'empty_name');
			elseif(empty($email))
				$this->design->assign('error', 'empty_email');
            elseif(empty($phone)) 
                $this->design->assign('error', 'empty_phone');
            elseif(empty($address)) 
                $this->design->assign('error', 'empty_address');    
			elseif($user_id = $this->users->update_user($this->user->id, array('name'=>$name, 'email'=>$email, 'phone'=>$phone, 'address'=>$address)))
			{
				$this->user = $this->users->get_user(intval($user_id));
				$this->design->assign('name', $this->user->name);
				$this->design->assign('user', $this->user);
				$this->design->assign('email', $this->user->email);
				$this->design->assign('phone', $this->user->phone);
                $this->design->assign('address', $this->user->address);
			}
			else
				$this->design->assign('error', 'unknown error');
			
			if(!empty($password))
			{
				$this->users->update_user($this->user->id, array('password'=>$password));
			}
	
		}
		else
		{
			// Передаем в шаблон
			$this->design->assign('name', $this->user->name);
			$this->design->assign('email', $this->user->email);	
            $this->design->assign('phone', $this->user->phone);
            $this->design->assign('address', $this->user->address);
		}
	
		$orders = $this->orders->get_orders(array('user_id'=>$this->user->id));
		$this->design->assign('orders', $orders);
		
		$this->design->assign('meta_title', $this->user->name);
		$body = $this->design->fetch('user.tpl');
		
		return $body;
	}
}

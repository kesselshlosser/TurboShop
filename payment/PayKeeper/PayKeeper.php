<?php

require_once('api/Turbo.php');

class PayKeeper extends Turbo
{	
	public function checkout_form($order_id, $button_text = null)
	{
		if(empty($button_text))
			$button_text = $this->translations->proceed_to_checkout;
		
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = $this->money->convert($order->total_price, $payment_method->currency_id, false);
		
		$success_url = $this->config->root_url.'/order/'.$order->url;
		
		$fail_url = $this->config->root_url.'/order/'.$order->url;


//////////////////////////////////////
      	$phone = preg_replace('/[^\d]/', '', $order->phone);
      	$phone = substr($phone, -min(10, strlen($phone)), 10);

      	$clientid = $order->user_id;


	$formdata = array(
		"phone" 	=> $phone,
		"clientid"	=> $clientid,
		"sum"		=> number_format($price, 2,'.',''),
		"orderid"	=> $order_id
	);


        //build the post string
        $poststring = "";
        foreach($formdata as $key => $val){
            $poststring .= urlencode($key) . "=" . urlencode($val) . "&";
        }
        // strip off trailing ampersand
        $poststring = substr($poststring, 0, -1);

	$url = $payment_settings['PAYKEEPER_PAYMENT_FORM_URL'];


	$html = '';	
        if( function_exists( "curl_init" )) {
        
            $CR = curl_init();
            curl_setopt($CR, CURLOPT_URL, $url);
            curl_setopt($CR, CURLOPT_POST, 1);
            curl_setopt($CR, CURLOPT_FAILONERROR, true); 
            curl_setopt($CR, CURLOPT_POSTFIELDS, $poststring);
            curl_setopt($CR, CURLOPT_RETURNTRANSFER, 1);
             
            curl_setopt($CR, CURLOPT_SSL_VERIFYPEER, 0);
            
            $result = curl_exec( $CR );
            
            $error = curl_error( $CR );
            if( !empty( $error )) {
              $html = "<br/><span class=message>"."INTERNAL ERROR:".$error."</span>";
              return false;
            }
            else {
	      $html = $result; 
            }

            curl_close( $CR );
        } else {
	  $payment_parameters = http_build_query(array( 
		"clientid"=>$clientid, 
		"orderid"=>$order_id, 
		"sum"=>number_format($price, 2,'.',''), 
		"phone"=>$phone));

	  $options = array("http"=>array( 
		"method"=>"POST", 
		"header"=>"Content-type: application/x-www-form-urlencoded", 
		"content"=>$payment_parameters 
	  )); 

	  $context = stream_context_create($options); 

	  $html = file_get_contents($url, false, $context);
        }
//////////////////////////////////////
		
		$button = $html;	

		return $button;
	}

}
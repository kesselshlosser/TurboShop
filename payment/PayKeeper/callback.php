<?php

/**
 * Turbo CMS
 *
 * @copyright 	Turbo CMS
 * @link 		https://turbo-cms.com
 * @author 		Turbo CMS
 *
 * К этому скрипту обращается PayKeeper в процессе оплаты
 *
 */
 
// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');
$turbo = new Turbo();

      // get request variables
      $request = $_POST;
      if (empty($request)) {
          die('Request doesn\'t contain POST elements.');
      }

      $the_Id		=  $request['id'];
      $the_Sum		=  $request['sum'];
      $the_Clientid	=  $request['clientid'];
      $the_Orderid	=  intval($request['orderid']);
      $the_Key		=  $request['key'];

          // check order id
      if (empty($the_Orderid) || strlen($the_Orderid) > 50)
          die('Missing or invalid order ID');


////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
	$the_order = $turbo->orders->get_order($the_Orderid);
	if(empty($the_order))
		die('Order not found');
 
// Нельзя оплатить уже оплаченный заказ  
	if($the_order->paid)
		die('Order has been paid already');

	$method = $turbo->payment->get_payment_method(intval($the_order->payment_method_id));
	if(empty($method))
		die("Unknown payment method");

	$our_price = $turbo->money->convert($the_order->total_price, $method->currency_id, false);
	$our_price = number_format($our_price, 2, '.', '');
 
	$settings = unserialize($method->settings);

	$TMGCO_SECRET_KEY = $settings['PAYKEEPER_SECRET'];

	$our_customerId = $the_order->user_id;




          // check client id
      if (!isset($the_Clientid) || strlen($the_Clientid) > 50)
          die('Missing or invalid client ID');

          // load client for further validation
      if ($our_customerId != $the_Clientid)
          die('Client not found');

      if ($our_price != $the_Sum)
          die('Incorrect amount');

      $our_key = $TMGCO_SECRET_KEY;

      $our_signature = md5($the_Id . $the_Sum . $the_Clientid . $the_Orderid . $our_key);

          // check transaction signature
      if($the_Key != $our_signature)
        die('Message digest incorrect');


////////////////////////////////////
// Проверка наличия товара
////////////////////////////////////


$purchases = $turbo->orders->get_purchases(array('order_id'=>intval($the_order->id)));
foreach($purchases as $purchase)
{
	$variant = $turbo->variants->get_variant(intval($purchase->variant_id));
	if(empty($variant) || (!$variant->infinity && $variant->stock < $purchase->amount))
	{
		die("Low stock of $purchase->product_name $purchase->variant_name");
	}
}
       
// Установим статус оплачен
$turbo->orders->update_order(intval($the_order->id), array('paid'=>1));

// Спишем товары  
$turbo->orders->close(intval($the_order->id));
$turbo->notify->email_order_user(intval($the_order->id));
$turbo->notify->email_order_admin(intval($the_order->id));


      $our_hash = md5($the_Id . $our_key);

      die("OK $our_hash");

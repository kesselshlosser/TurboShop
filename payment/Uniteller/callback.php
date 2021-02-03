<?php

/**
 * Turbo CMS
 * 
 * @link		http://rlab.pro
 * @author		OsBen
 * @mail		php@rlab.pro
 *
 * Оплата через Интернет-эквайринг через Uniteller
 *
 */
 
// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');
$turbo = new Turbo();

mail('pikusov@gmail.com', 'uniteller', print_r($_POST, true));

$order_id = $turbo->request->post('Order_ID', 'integer');

$order = $turbo->orders->get_order(intval($order_id));
if(empty($order) && !empty($order_id))
	die('Оплачиваемый заказ не найден');


$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
$settings = unserialize($method->settings);
if($_POST["Signature"] = strtoupper(md5($order_id . $_POST["Status"] . $settings['uniteller_password'])))
{
	if( strtolower($_POST["Status"]) == 'authorized')
	{
		// Установим статус оплачен
		$turbo->orders->update_order(intval($order->id), array('paid'=>1));

		// Отправим уведомление на email
		$turbo->notify->email_order_user(intval($order->id));
		$turbo->notify->email_order_admin(intval($order->id));

		// Спишем товары  
		$turbo->orders->close(intval($order->id));

	}
}

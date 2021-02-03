<?php

/**
 * Turbo CMS
 *
 * @copyright 	Turbo CMS
 * @link 		https://turbo-cms.com
 * @author 		Turbo CMS
 *
 * К этому скрипту обращается Liqpay в процессе оплаты
 *
 */

// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');
$turbo = new Turbo();

// Выбираем из xml нужные данные
$public_key		 	= $turbo->request->post('public_key');
$amount				= $turbo->request->post('amount');
$currency			= $turbo->request->post('currency');
$description		= $turbo->request->post('description');
$liqpay_order_id	= $turbo->request->post('order_id');
$order_id			= intval(substr($liqpay_order_id, 0, strpos($liqpay_order_id, '-')));
$type				= $turbo->request->post('type');
$signature			= $turbo->request->post('signature');
$status				= $turbo->request->post('status');
$transaction_id		= $turbo->request->post('transaction_id');
$sender_phone		= $turbo->request->post('sender_phone');

if($status !== 'success')
	die("bad status");

if($type !== 'buy')
	die("bad type");

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $turbo->orders->get_order(intval($order_id));
if(empty($order))
	die('Оплачиваемый заказ не найден');
 
////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Неизвестный метод оплаты");
	
$settings = unserialize($method->settings);
$payment_currency = $turbo->money->get_currency(intval($method->currency_id));

// Валюта должна совпадать
if($currency !== $payment_currency->code)
	die("bad currency");

// Проверяем контрольную подпись
$mysignature = base64_encode(sha1($settings['liqpay_private_key'].$amount.$currency.$public_key.$liqpay_order_id.$type.$description.$status.$transaction_id.$sender_phone, 1));
if($mysignature !== $signature)
	die("bad sign".$signature);

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	die('order already paid');

if($amount != round($turbo->money->convert($order->total_price, $method->currency_id, false), 2) || $amount<=0)
	die("incorrect price");
	       
// Установим статус оплачен
$turbo->orders->update_order(intval($order->id), array('paid'=>1));

// Отправим уведомление на email
$turbo->notify->email_order_user(intval($order->id));
$turbo->notify->email_order_admin(intval($order->id));

// Спишем товары  
$turbo->orders->close(intval($order->id));

// Перенаправим пользователя на страницу заказа
// header('Location: '.$turbo->config->root_url.'/order/'.$order->url);

exit();
<?php

function response($code = 200, $response = "") {
    http_response_code($code);
}

// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');
$turbo = new Turbo();

$payment = $_POST['payment'];
$signature = $_POST['signature'];

parse_str($payment, $payment_url);

if (empty($payment_url['order']))
    response(400, "Оплачиваемый заказ не найден");
else
    $order_url = $payment_url['order'];

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $turbo->orders->get_order((string)$order_url);
if(empty($order))
  response(400, 'Оплачиваемый заказ не найден');

// Нельзя оплатить уже оплаченный заказ
if($order->paid)
  response(400, 'Этот заказ уже оплачен');

$settings = $turbo->payment->get_payment_settings($order->payment_method_id);

if (empty($settings))
    response(400, 'Ошибка');

if ($signature != sha1(md5($payment . $settings['privat24_pass'])))
    response(400, "bad sign\n");

if ($payment_url['state'] == 'fail')
    response(400, "ошибка");


////////////////////////////////////
// Проверка наличия товара
////////////////////////////////////
$purchases = $turbo->orders->get_purchases(array('order_id' => intval($order->id)));
foreach($purchases as $purchase)
{
  $variant = $turbo->variants->get_variant(intval($purchase->variant_id));
  if(empty($variant) || (!$variant->infinity && $variant->stock < $purchase->amount))
  {
    response(400, "Нехватка товара $purchase->product_name $purchase->variant_name");
  }
}

// Установим статус оплачен
$turbo->orders->update_order(intval($order->id), array('paid' => 1));

// Спишем товары
$turbo->orders->close(intval($order->id));
$turbo->notify->email_order_user(intval($order->id));
$turbo->notify->email_order_admin(intval($order->id));


response(200, "ok");
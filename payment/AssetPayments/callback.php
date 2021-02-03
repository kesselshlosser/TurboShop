<?php

chdir ('../../');
require_once('api/Turbo.php');

		// Выбираем данные
		$json = json_decode(file_get_contents('php://input'), true);

		$turbo = new Turbo();
		$order_id = $json['Order']['OrderId'];
		$order = $turbo->orders->get_order(intval($order_id));
		$payment_method = $turbo->payment->get_payment_method($order->payment_method_id);
		$settings = $turbo->payment->get_payment_settings($payment_method->id);
		

		$key = $settings['merchant_id'];
		$secret = $settings['secret_key'];
		$transactionId = $json['Payment']['TransactionId'];
		$signature = $json['Payment']['Signature'];
		$amount = $json['Order']['Amount'];
		$currency = $json['Order']['Currency'];
		$status = $json['Payment']['StatusCode'];
		$requestSign =$key.':'.$transactionId.':'.strtoupper($secret);
		$sign = hash_hmac('md5',$requestSign,$secret);
		

		if ($status == 1 && $sign == $signature) {
			// Установим статус оплачен
			$turbo->orders->update_order(intval($order->id), array('paid' => 1));
            
			// Отправим уведомление на email
            $turbo->notify->email_order_user(intval($order->id));
            $turbo->notify->email_order_admin(intval($order->id));
            
			// Спишем товары
            $turbo->orders->close(intval($order->id));
		} else {
			$turbo->orders->update_order(intval($order->id), array('paid' => 0));
		}
				
?>
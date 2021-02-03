<?php
set_error_handler('exceptions_error_handler', E_ALL);
function exceptions_error_handler($severity)
{
    if (error_reporting() == 0) {
        return;
    }
    if (error_reporting() & $severity) {
        die('NOTOK');
    }
}

try {
    chdir('../../');
    require_once('api/Turbo.php');
    $turbo = new Turbo();
    $request = json_decode(file_get_contents("php://input"));
    $request->Success = $request->Success ? 'true' : 'false';

    foreach ($request as $key => $item) {
        $requestData[$key] = $item;
    }

    $order = $turbo->orders->get_order(intval($requestData['OrderId']));
    $method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
    $settings = unserialize($method->settings);

    $requestData['Password'] = $settings['tinkoff_secret'];
    $originalToken = $requestData['Token'];
    ksort($requestData);

    if (isset($requestData['Token'])) {
        unset($requestData['Token']);
    }

    $values = implode('', array_values($requestData));
    $genToken = hash('sha256', $values);

    if ($genToken != $originalToken) {
        die('NOTOK');
    }

    if ($requestData['Status'] == 'AUTHORIZED' && $order->status == 2) {
        die('OK');
    }

    if ($requestData['Status'] == 'CONFIRMED') {
        $update_array = array('paid' => 1, 'status' => 2);
        // Установим статус оплачен
        $turbo->orders->update_order(intval($order->id), $update_array);
        // Спишем товары
        $turbo->orders->close(intval($order->id));
    }
    die('OK');
} catch (Exception $e) {
    die('NOTOK');
}

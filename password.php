<?php
session_start();
?>

<html>
<head>
	<title>Восстановления пароля администратора</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
	<meta http-equiv="Content-Language" content="ru" />
</head>
<style>
	html, body {
		margin: 0;
		padding: 0;
		background-color: #eef2f4;
		font-family:tahoma, verdana;
	}
	h1{font-size:26px; font-weight:normal}
	p{font-size:19px;}
	input{font-size:18px;}
	p.error{color:red;}
	div.maindiv{width: 600px; height: 300px; position: relative; left: 50%; top: 100px; margin-left: -250px;}
	p.success{color:green;}
	.body {
		max-width: 600px;
		margin: 5% auto;
		padding: 40px;
		background: #fff;
	}
	input,
	textarea {
		display: block;
		box-sizing: border-box;
		-moz-box-sizing: border-box;
		height: 40px;
		padding: 8px 10px;
		outline: none;
		border: 1px solid #dfe2e5;
		border-radius: 2px;
		background: #fff;
		appearance: normal;
		-moz-appearance: none;
		-webkit-appearance: none;
	}
	input{
		display: inline-block;
		line-height: 1;
	}
	input:focus{
		background-color: #f0f0f0;
		border-color: rgba(0, 0, 0, 0.1);
	}
	input[type="submit"]{
		background-color: #2fc7f7;
		border-color: #2fc7f7;
		color: #fff;
		cursor: pointer;
		margin-top: 3px;
	}
	input[type="submit"]:hover{
		background-color: #3fddff;
		border-color: #3fddff;
		color: #fff;
	}
	@media screen and (max-width: 600px) {
		.body {
			padding: 20px;
		}
	}
</style>
<body>
<div style='width:100%; height:100%;'> 
  <div class="maindiv">

<?php
require_once('api/Turbo.php');
$turbo = new Turbo();

// Если пришли по ссылке из письма
if($c = $turbo->request->get('code'))
{
	// Код не совпадает - прекращяем работу
	if(empty($_SESSION['admin_password_recovery_code']) || empty($c) || $_SESSION['admin_password_recovery_code'] !== $c)
	{
		header('Location:password.php');
		exit();
	}
	
	// IP не совпадает - прекращяем работу
	if(empty($_SESSION['admin_password_recovery_ip'])|| empty($_SERVER['REMOTE_ADDR']) || $_SESSION['admin_password_recovery_ip'] !== $_SERVER['REMOTE_ADDR'])
	{
		header('Location:password.php');
		exit();
	}
	
	// Если запостили пароль
	if($new_password = $turbo->request->post('new_password'))
	{
		// Файл с паролями
		$passwd_file = $turbo->config->root_dir.'turbo/.passwd';
		
		// Удаляем из сесси код, чтобы больше никто не воспользовался ссылкой
		unset($_SESSION['admin_password_recovery_code']);
		unset($_SESSION['admin_password_recovery_ip']);

		// Если в файлы запрещена запись - предупреждаем об этом
		if(!is_writable($passwd_file))
		{
			print "
				<h1>Восстановление пароля администратора</h1>
				<p class='error'>
				Файл /turbo/.passwd недоступен для записи.
				</p>
				<p>Вам нужно зайти по FTP и изменить права доступа к этому файлу, после чего повторить процедуру восстановления пароля.</p>
			";
		}
		else
		{
			// Новый логин и пароль
			$new_login = $turbo->request->post('new_login');
			$new_password = $turbo->request->post('new_password');
			if(!$turbo->managers->update_manager($new_login, array('password'=>$new_password)))
				$turbo->managers->add_manager(array('login'=>$new_login, 'password'=>$new_password));
			
			print "
				<h1>Восстановление пароля администратора</h1>
				<p class='success'>
				Новый пароль установлен
				</p>
				<p>
				<a href='".$turbo->root_url."/turbo/index.php?module=ManagersAdmin'>Перейти в панель управления</a>
				</p>
			";
		}
	}
	else
	{
	// Форма указалия нового логина и пароля
	print "
		<h1>Восстановление пароля администратора</h1>
		<p>
		<form method=post>
			Новый логин:<br><input type='text' name='new_login'><br><br>
			Новый пароль:<br><input type='password' name='new_password'><br><br>
			<input type='submit' value='Сохранить логин и пароль'>
		</form>
		</p>
		";
	}
}
else
{
	print "
		<h1>Восстановление пароля администратора</h1>
		<p>
		Введите email администратора
		<form method='post' action='".$turbo->root_url."/password.php'>
			<input type='text' name='email'>
			<input type='submit' value='Восстановить пароль'>
		</form>
		</p>
	";

	$admin_email = $turbo->settings->admin_email;
	
	if(isset($_POST['email']))
	{
		if($_POST['email'] === $admin_email)
		{
			$code = $turbo->config->token(mt_rand(1, mt_getrandmax()).mt_rand(1, mt_getrandmax()).mt_rand(1, mt_getrandmax()));
			$_SESSION['admin_password_recovery_code'] = $code;
			$_SESSION['admin_password_recovery_ip'] = $_SERVER['REMOTE_ADDR'];
			
			$message = 'Вы или кто-то другой запросил ссылку на восстановление пароля администратора.<br>';
			$message .= 'Для смены пароля перейдите по ссылке '.$turbo->config->root_url.'/password.php?code='.$code.'<br>';
			$message .= 'Если письмо пришло вам по ошибке, проигнорируйте его.';
			
			$turbo->notify->email($admin_email, 'Восстановление пароля администратора '.$turbo->settings->site_name, $message, $turbo->settings->notify_from_email);
		}
		print "Вам отправлена ссылка для восстановления пароля. Если письмо вам не пришло, значит вы неверно указали email или что-то не так с хостингом";
	}

}
?>

  </div>
</div>
</body>
</html>

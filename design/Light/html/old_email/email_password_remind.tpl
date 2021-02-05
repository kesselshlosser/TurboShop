{* Password recovery email *}
	
{$subject = $lang->new_password scope=global}
<html>
	<body>
		<p>{$user->name|escape}, {$lang->on_the_site} <a href='{$config->root_url}/{$lang_link}'>{$settings->site_name}</a> {$lang->email_password_was_reply}</p>
		<p>{$lang->email_password_change_pass}:</p>
		<p><a href='{$config->root_url}/{$lang_link}user/password_remind/{$code}'>{$lang->change_password}</a></p>
		<p>{$lang->email_password_text}</p>
	</body>
</html>


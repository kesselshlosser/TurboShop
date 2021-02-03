<?PHP
	
require_once('api/Turbo.php');


############################################
# Class goodCategories displays a list of products categories
############################################
class StatsAdmin extends Turbo
{
	
	public function fetch()
	{
		return $this->design->fetch('stats.tpl');
	}
}

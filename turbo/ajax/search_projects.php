<?php
	require_once('../../api/Turbo.php');
	$turbo = new Turbo();
	$limit = 100;
	
	$keyword = $turbo->request->get('query', 'string');
	
	$keywords = explode(' ', $keyword);
	$keyword_sql = '';
	foreach($keywords as $keyword)
	{
				$kw = $turbo->db->escape(trim($keyword));
				$keyword_sql .= $turbo->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%')");
	}
	
	
	$turbo->db->query('SELECT p.id, p.name, i.filename as image FROM __projects p
	                    LEFT JOIN __images_project i ON i.project_id=p.id AND i.position=(SELECT MIN(position) FROM __images_project WHERE project_id=p.id LIMIT 1)
	                    WHERE 1 '.$keyword_sql.' ORDER BY p.name LIMIT ?', $limit);
	$projects = $turbo->db->results();

	$suggestions = array();
	foreach($projects as $project)
	{
		if(!empty($project->image))
			$project->image = $turbo->design->resize_modifier($project->image, 35, 35);
		
		$suggestion = new stdClass();
		$suggestion->value = $project->name;
		$suggestion->data = $project;
		$suggestions[] = $suggestion;
	}
	
	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $suggestions;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);

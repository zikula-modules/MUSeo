<?php
/**
 * MUSeo.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @package MUSeo
 * @author Michael Ueberschaer <kontakt@webdesign-in-bremen.com>.
 * @link http://webdesign-in-bremen.com
 * @link http://zikula.org
 * @version Generated by ModuleStudio 0.7.0 (http://modulestudio.de).
 */

/**
 * This is the HandleModules api helper class.
 */
class MUSeo_Api_HandleModules extends MUSeo_Api_Base_HandleModules
{
    /**
     * Returns the supported modules set in the configuration.
     *
     * @return array $modules
     */
    public static function checkModules()
    {
        $modules = ModUtil::getVar('MUSeo', 'modules');
        $modules = explode(',', $modules);

        return $modules;
    }

    /**
     * This method is for setting metatags.
     *
     * @param string $modname
     * @param string $modfunc default main
     */
    public static function setModuleMetaTags($modname, $modfunc = 'main')
    {
        $request = new Zikula_Request_Http();

        $metatagRepository = MUSeo_Util_Model::getMetatagRepository();
        $where = 'tbl.theModule = \'' . DataUtil::formatForStore($modname) . '\'';
        $where .= ' AND ';
        $where .= 'tbl.functionOfModule = \'' . DataUtil::formatForStore($modfunc) . '\'';

        $extensionRepository = MUSeo_Util_Model::getExtensionRepository();
        $where2 = 'tbl.name = \'' . DataUtil::formatForStore($modname) . '\'';
        $extensionInfo = $extensionRepository->selectWhere($where2);

        if (count($extensionInfo) < 1) {
            return;
        }

        $extensionInfo = $extensionInfo[0];

        if ($extensionInfo['controllerForView'] == $modfunc) {
            $objectType = $request->query->filter($extensionInfo['parameterForObjects'], '', FILTER_SANITIZE_STRING);
            if ($objectType != '') {
                $where .= ' AND ';
                $where .= 'tbl.objectOfModule = \'' . DataUtil::formatForStore($objectType) . '\'';
            }

            $objectId = $request->query->filter($extensionInfo['nameOfIdentifier'], 0, FILTER_SANITIZE_STRING);
            $where .= ' AND ';
            $where .= 'tbl.idOfObject = \'' . DataUtil::formatForStore($objectId) . '\'';

            $objectString = $request->query->filter($extensionInfo['nameOfIdentifier'], '', FILTER_SANITIZE_STRING);
            $where .= ' AND ';
            $where .= 'tbl.stringOfObject = \'' . DataUtil::formatForStore($objectString) . '\'';
        }

        if ($extensionInfo['controllerForSingleObject'] == $modfunc && $extensionInfo['controllerForView'] != $extensionInfo['controllerForSingleObject']) {
            $objectType = $request->query->filter($extensionInfo['parameterForObjects'], '', FILTER_SANITIZE_STRING);
            if ($objectType != '') {
                $where .= ' AND ';
                $where .= 'tbl.objectOfModule = \'' . DataUtil::formatForStore($objectType) . '\'';
            }

            if ($modname != 'PostCalendar') {
                $objectId = $request->query->filter($extensionInfo['nameOfIdentifier'], 0, FILTER_SANITIZE_STRING);
                if ($objectId > 0) {
                    $where .= ' AND ';
                    $where .= 'tbl.idOfObject = \'' . DataUtil::formatForStore($objectId) . '\'';
                }
                $objectString = $request->query->filter($extensionInfo['nameOfIdentifier'], '', FILTER_SANITIZE_STRING);
                if ($objectString != '') {
                    $where .= ' OR ';
                    $where .= 'tbl.stringOfObject = \'' . DataUtil::formatForStore($objectString) . '\'';
                }
            }
        }
        if ($extensionInfo['extraIdentifier'] != '') {
            $identifiers = explode(',', $extensionInfo['extraIdentifier']);

            foreach ($identifiers as $identifier) {
                $result = $request->query->filter($identifier, '');
                if ($result != '') {
                    $where .= ' AND ';
                    $where .= 'tbl.extraInfos LIKE \'%' . $identifier . '=' . $result . '%\'';
                } else {
                    $where .= ' AND ';
                    $where .= 'tbl.extraInfos NOT LIKE \'%' . $identifier . '%\'';
                }
            }
        }
        
        // we get default string for robots
        $robots = ModUtil::getVar('MUSeo', 'robots');
        $robotsTag = '<meta name="ROBOTS" content="' . $robots . '" />';

        // we get the entity
        $entities = $metatagRepository->selectWhere($where);

        if (count($entities) > 0) {
            $entity = $entities[0];
            if (!empty($entity['title'])) {
                PageUtil::setVar('title', $entity['title']);
            }
            if (!empty($entity['description'])) {
                PageUtil::setVar('description', $entity['description']);
            }
            if (!empty($entity['keywords'])) {
                PageUtil::setVar('keywords', $entity['keywords']);
            }
            if (!empty($entity['robots'])) {
                $robotsTag = '<meta name="ROBOTS" content="' . $entity['robots'] . '" />';
            }
        }

        PageUtil::setVar('header', $robotsTag);
    }
}

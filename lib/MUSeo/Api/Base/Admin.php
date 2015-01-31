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
 * This is the Admin api helper class.
 */
class MUSeo_Api_Base_Admin extends Zikula_AbstractApi
{
    /**
     * Returns available admin panel links.
     *
     * @return array Array of admin links.
     */
    public function getLinks()
    {
        $links = array();

        if (SecurityUtil::checkPermission($this->name . '::', '::', ACCESS_READ)) {
            $links[] = array('url' => ModUtil::url($this->name, 'user', 'main'),
                             'text' => $this->__('Frontend'),
                             'title' => $this->__('Switch to user area.'),
                             'class' => 'z-icon-es-home');
        }

        $controllerHelper = new MUSeo_Util_Controller($this->serviceManager);
        $utilArgs = array('api' => 'admin', 'action' => 'getLinks');
        $allowedObjectTypes = $controllerHelper->getObjectTypes('api', $utilArgs);

        $currentType = $this->request->query->filter('type', 'metatag', FILTER_SANITIZE_STRING);
        $currentLegacyType = $this->request->query->filter('lct', 'user', FILTER_SANITIZE_STRING);
        $permLevel = in_array('admin', array($currentType, $currentLegacyType)) ? ACCESS_ADMIN : ACCESS_READ;

        if (in_array('metatag', $allowedObjectTypes)
            && SecurityUtil::checkPermission($this->name . ':Metatag:', '::', $permLevel)) {
            $links[] = array('url' => ModUtil::url($this->name, 'admin', 'view', array('ot' => 'metatag')),
                             'text' => $this->__('Metatags'),
                             'title' => $this->__('Metatag list'));
        }
        if (in_array('extension', $allowedObjectTypes)
            && SecurityUtil::checkPermission($this->name . ':Extension:', '::', $permLevel)) {
            $links[] = array('url' => ModUtil::url($this->name, 'admin', 'view', array('ot' => 'extension')),
                             'text' => $this->__('Extensions'),
                             'title' => $this->__('Extension list'));
        }
        if (SecurityUtil::checkPermission($this->name . '::', '::', ACCESS_ADMIN)) {
            $links[] = array('url' => ModUtil::url($this->name, 'admin', 'config'),
                             'text' => $this->__('Configuration'),
                             'title' => $this->__('Manage settings for this application'));
        }

        return $links;
    }
}

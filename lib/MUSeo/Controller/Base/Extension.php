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
 * Extension controller base class.
 */
class MUSeo_Controller_Base_Extension extends Zikula_AbstractController
{
    /**
     * Post initialise.
     *
     * Run after construction.
     *
     * @return void
     */
    protected function postInitialize()
    {
        // Set caching to false by default.
        $this->view->setCaching(Zikula_View::CACHE_DISABLED);
    }

    /**
     * This method is the default function handling the main area called without defining arguments.
     *
     *
     * @return mixed Output.
     */
    public function main()
    {
        $legacyControllerType = $this->request->query->filter('lct', 'user', FILTER_SANITIZE_STRING);
        System::queryStringSetVar('type', $legacyControllerType);
        $this->request->query->set('type', $legacyControllerType);
    
        $controllerHelper = new MUSeo_Util_Controller($this->serviceManager);
        
        // parameter specifying which type of objects we are treating
        $objectType = 'extension';
        $utilArgs = array('controller' => 'extension', 'action' => 'main');
        $permLevel = $legacyControllerType == 'admin' ? ACCESS_ADMIN : ACCESS_OVERVIEW;
        $this->throwForbiddenUnless(SecurityUtil::checkPermission($this->name . ':' . ucfirst($objectType) . ':', '::', $permLevel), LogUtil::getErrorMsgPermission());
        
        if ($legacyControllerType == 'admin') {
            
            $redirectUrl = ModUtil::url($this->name, 'extension', 'view', array('lct' => $legacyControllerType));
            
            return $this->redirect($redirectUrl);
        }
        
        if ($legacyControllerType != 'admin') {
            
            $redirectUrl = ModUtil::url($this->name, 'extension', 'view', array('lct' => $legacyControllerType));
            
            return $this->redirect($redirectUrl);
        }
        
        // set caching id
        $this->view->setCacheId('extension_main');
        
        // return main template
        return $this->view->fetch('extension/main.tpl');
    }
    
    /**
     * This method provides a item list overview.
     *
     * @param string  $sort         Sorting field.
     * @param string  $sortdir      Sorting direction.
     * @param int     $pos          Current pager position.
     * @param int     $num          Amount of entries to display.
     * @param string  $tpl          Name of alternative template (to be used instead of the default template).
     * @param boolean $raw          Optional way to display a template instead of fetching it (required for standalone output).
     *
     * @return mixed Output.
     */
    public function view()
    {
        $legacyControllerType = $this->request->query->filter('lct', 'user', FILTER_SANITIZE_STRING);
        System::queryStringSetVar('type', $legacyControllerType);
        $this->request->query->set('type', $legacyControllerType);
    
        $controllerHelper = new MUSeo_Util_Controller($this->serviceManager);
        
        // parameter specifying which type of objects we are treating
        $objectType = 'extension';
        $utilArgs = array('controller' => 'extension', 'action' => 'view');
        $permLevel = $legacyControllerType == 'admin' ? ACCESS_ADMIN : ACCESS_READ;
        $this->throwForbiddenUnless(SecurityUtil::checkPermission($this->name . ':' . ucfirst($objectType) . ':', '::', $permLevel), LogUtil::getErrorMsgPermission());
        $entityClass = $this->name . '_Entity_' . ucfirst($objectType);
        $repository = $this->entityManager->getRepository($entityClass);
        $repository->setControllerArguments(array());
        $viewHelper = new MUSeo_Util_View($this->serviceManager);
        
        // parameter for used sorting field
        $sort = $this->request->query->filter('sort', '', FILTER_SANITIZE_STRING);
        if (empty($sort) || !in_array($sort, $repository->getAllowedSortingFields())) {
            $sort = $repository->getDefaultSortingField();
        }
        
        // parameter for used sort order
        $sortdir = $this->request->query->filter('sortdir', '', FILTER_SANITIZE_STRING);
        $sortdir = strtolower($sortdir);
        if ($sortdir != 'asc' && $sortdir != 'desc') {
            $sortdir = 'asc';
        }
        
        // convenience vars to make code clearer
        $currentUrlArgs = array();
        
        $where = '';
        
        $selectionArgs = array(
            'ot' => $objectType,
            'where' => $where,
            'orderBy' => $sort . ' ' . $sortdir
        );
        
        $showOwnEntries = (int) $this->request->query->filter('own', $this->getVar('showOnlyOwnEntries', 0), FILTER_VALIDATE_INT);
        $showAllEntries = (int) $this->request->query->filter('all', 0, FILTER_VALIDATE_INT);
        
        if (!$showAllEntries) {
            $csv = (int) $this->request->query->filter('usecsvext', 0, FILTER_VALIDATE_INT);
            if ($csv == 1) {
                $showAllEntries = 1;
            }
        }
        
        $this->view->assign('showOwnEntries', $showOwnEntries)
                   ->assign('showAllEntries', $showAllEntries);
        if ($showOwnEntries == 1) {
            $currentUrlArgs['own'] = 1;
        }
        if ($showAllEntries == 1) {
            $currentUrlArgs['all'] = 1;
        }
        
        // prepare access level for cache id
        $accessLevel = ACCESS_READ;
        $component = 'MUSeo:' . ucfirst($objectType) . ':';
        $instance = '::';
        if (SecurityUtil::checkPermission($component, $instance, ACCESS_COMMENT)) {
            $accessLevel = ACCESS_COMMENT;
        }
        if (SecurityUtil::checkPermission($component, $instance, ACCESS_EDIT)) {
            $accessLevel = ACCESS_EDIT;
        }
        
        $templateFile = $viewHelper->getViewTemplate($this->view, $objectType, 'view', array());
        $cacheId = $objectType . '_view|_sort_' . $sort . '_' . $sortdir;
        $resultsPerPage = 0;
        if ($showAllEntries == 1) {
            // set cache id
            $this->view->setCacheId($cacheId . '_all_1_own_' . $showOwnEntries . '_' . $accessLevel);
        
            // if page is cached return cached content
            if ($this->view->is_cached($templateFile)) {
                return $viewHelper->processTemplate($this->view, $objectType, 'view', array(), $templateFile);
            }
        
            // retrieve item list without pagination
            $entities = ModUtil::apiFunc($this->name, 'selection', 'getEntities', $selectionArgs);
        } else {
            // the current offset which is used to calculate the pagination
            $currentPage = (int) $this->request->query->filter('pos', 1, FILTER_VALIDATE_INT);
        
            // the number of items displayed on a page for pagination
            $resultsPerPage = (int) $this->request->query->filter('num', 0, FILTER_VALIDATE_INT);
            if ($resultsPerPage == 0) {
                $resultsPerPage = $this->getVar('pageSize', 10);
            }
        
            // set cache id
            $this->view->setCacheId($cacheId . '_amount_' . $resultsPerPage . '_page_' . $currentPage . '_own_' . $showOwnEntries . '_' . $accessLevel);
        
            // if page is cached return cached content
            if ($this->view->is_cached($templateFile)) {
                return $viewHelper->processTemplate($this->view, $objectType, 'view', array(), $templateFile);
            }
        
            // retrieve item list with pagination
            $selectionArgs['currentPage'] = $currentPage;
            $selectionArgs['resultsPerPage'] = $resultsPerPage;
            list($entities, $objectCount) = ModUtil::apiFunc($this->name, 'selection', 'getEntitiesPaginated', $selectionArgs);
        
            $this->view->assign('currentPage', $currentPage)
                       ->assign('pager', array('numitems'     => $objectCount,
                                               'itemsperpage' => $resultsPerPage));
        }
        
        foreach ($entities as $k => $entity) {
            $entity->initWorkflow();
        }
        
        // build ModUrl instance for display hooks
        $currentUrlObject = new Zikula_ModUrl($this->name, 'extension', 'view', ZLanguage::getLanguageCode(), $currentUrlArgs);
        
        // assign the object data, sorting information and details for creating the pager
        $this->view->assign('items', $entities)
                   ->assign('sort', $sort)
                   ->assign('sdir', $sortdir)
                   ->assign('pageSize', $resultsPerPage)
                   ->assign('currentUrlObject', $currentUrlObject)
                   ->assign($repository->getAdditionalTemplateParameters('controllerAction', $utilArgs));
        
        $modelHelper = new MUSeo_Util_Model($this->serviceManager);
        $this->view->assign('canBeCreated', $modelHelper->canBeCreated($objectType));
        
        // fetch and return the appropriate template
        return $viewHelper->processTemplate($this->view, $objectType, 'view', array(), $templateFile);
    }
    
    /**
     * This method provides a handling of edit requests.
     *
     * @param string  $tpl          Name of alternative template (to be used instead of the default template).
     * @param boolean $raw          Optional way to display a template instead of fetching it (required for standalone output).
     *
     * @return mixed Output.
     */
    public function edit()
    {
        $legacyControllerType = $this->request->query->filter('lct', 'user', FILTER_SANITIZE_STRING);
        System::queryStringSetVar('type', $legacyControllerType);
        $this->request->query->set('type', $legacyControllerType);
    
        $controllerHelper = new MUSeo_Util_Controller($this->serviceManager);
        
        // parameter specifying which type of objects we are treating
        $objectType = 'extension';
        $utilArgs = array('controller' => 'extension', 'action' => 'edit');
        $permLevel = $legacyControllerType == 'admin' ? ACCESS_ADMIN : ACCESS_EDIT;
        $this->throwForbiddenUnless(SecurityUtil::checkPermission($this->name . ':' . ucfirst($objectType) . ':', '::', $permLevel), LogUtil::getErrorMsgPermission());
        
        // create new Form reference
        $view = FormUtil::newForm($this->name, $this);
        
        // build form handler class name
        $handlerClass = $this->name . '_Form_Handler_Extension_Edit';
        
        // determine the output template
        $viewHelper = new MUSeo_Util_View($this->serviceManager);
        $template = $viewHelper->getViewTemplate($this->view, $objectType, 'edit', array());
        
        // execute form using supplied template and page event handler
        return $view->execute($template, new $handlerClass());
    }
    
    /**
     * This method provides a handling of simple delete requests.
     *
     * @param int     $id           Identifier of entity to be shown.
     * @param boolean $confirmation Confirm the deletion, else a confirmation page is displayed.
     * @param string  $tpl          Name of alternative template (to be used instead of the default template).
     * @param boolean $raw          Optional way to display a template instead of fetching it (required for standalone output).
     *
     * @return mixed Output.
     */
    public function delete()
    {
        $legacyControllerType = $this->request->query->filter('lct', 'user', FILTER_SANITIZE_STRING);
        System::queryStringSetVar('type', $legacyControllerType);
        $this->request->query->set('type', $legacyControllerType);
    
        $controllerHelper = new MUSeo_Util_Controller($this->serviceManager);
        
        // parameter specifying which type of objects we are treating
        $objectType = 'extension';
        $utilArgs = array('controller' => 'extension', 'action' => 'delete');
        $permLevel = $legacyControllerType == 'admin' ? ACCESS_ADMIN : ACCESS_DELETE;
        $this->throwForbiddenUnless(SecurityUtil::checkPermission($this->name . ':' . ucfirst($objectType) . ':', '::', $permLevel), LogUtil::getErrorMsgPermission());
        $idFields = ModUtil::apiFunc($this->name, 'selection', 'getIdFields', array('ot' => $objectType));
        
        // retrieve identifier of the object we wish to delete
        $idValues = $controllerHelper->retrieveIdentifier($this->request, array(), $objectType, $idFields);
        $hasIdentifier = $controllerHelper->isValidIdentifier($idValues);
        
        $this->throwNotFoundUnless($hasIdentifier, $this->__('Error! Invalid identifier received.'));
        
        $selectionArgs = array('ot' => $objectType, 'id' => $idValues);
        
        $entity = ModUtil::apiFunc($this->name, 'selection', 'getEntity', $selectionArgs);
        $this->throwNotFoundUnless($entity != null, $this->__('No such item.'));
        
        $entity->initWorkflow();
        
        // determine available workflow actions
        $workflowHelper = new MUSeo_Util_Workflow($this->serviceManager);
        $actions = $workflowHelper->getActionsForObject($entity);
        if ($actions === false || !is_array($actions)) {
            return LogUtil::registerError($this->__('Error! Could not determine workflow actions.'));
        }
        
        // check whether deletion is allowed
        $deleteActionId = 'delete';
        $deleteAllowed = false;
        foreach ($actions as $actionId => $action) {
            if ($actionId != $deleteActionId) {
                continue;
            }
            $deleteAllowed = true;
            break;
        }
        if (!$deleteAllowed) {
            return LogUtil::registerError($this->__('Error! It is not allowed to delete this extension.'));
        }
        
        $confirmation = (bool) $this->request->request->filter('confirmation', false, FILTER_VALIDATE_BOOLEAN);
        if ($confirmation && $deleteAllowed) {
            $this->checkCsrfToken();
        
            $hookAreaPrefix = $entity->getHookAreaPrefix();
            $hookType = 'validate_delete';
            // Let any hooks perform additional validation actions
            $hook = new Zikula_ValidationHook($hookAreaPrefix . '.' . $hookType, new Zikula_Hook_ValidationProviders());
            $validators = $this->notifyHooks($hook)->getValidators();
            if (!$validators->hasErrors()) {
                // execute the workflow action
                $success = $workflowHelper->executeAction($entity, $deleteActionId);
                if ($success) {
                    $this->registerStatus($this->__('Done! Item deleted.'));
                }
        
                // Let any hooks know that we have created, updated or deleted the extension
                $hookType = 'process_delete';
                $hook = new Zikula_ProcessHook($hookAreaPrefix . '.' . $hookType, $entity->createCompositeIdentifier());
                $this->notifyHooks($hook);
        
                // The extension was deleted, so we clear all cached pages this item.
                $cacheArgs = array('ot' => $objectType, 'item' => $entity);
                ModUtil::apiFunc($this->name, 'cache', 'clearItemCache', $cacheArgs);
        
                if ($legacyControllerType == 'admin') {
                    // redirect to the list of extensions
                    $redirectUrl = ModUtil::url($this->name, 'extension', 'view', array('lct' => $legacyControllerType));
                } else {
                    // redirect to the list of extensions
                    $redirectUrl = ModUtil::url($this->name, 'extension', 'view', array('lct' => $legacyControllerType));
                }
                return $this->redirect($redirectUrl);
            }
        }
        
        $entityClass = $this->name . '_Entity_' . ucfirst($objectType);
        $repository = $this->entityManager->getRepository($entityClass);
        
        // set caching id
        $this->view->setCaching(Zikula_View::CACHE_DISABLED);
        
        // assign the object we loaded above
        $this->view->assign($objectType, $entity)
                   ->assign($repository->getAdditionalTemplateParameters('controllerAction', $utilArgs));
        
        // fetch and return the appropriate template
        $viewHelper = new MUSeo_Util_View($this->serviceManager);
        
        return $viewHelper->processTemplate($this->view, $objectType, 'delete', array());
    }
    

    /**
     * Process status changes for multiple items.
     *
     * This function processes the items selected in the admin view page.
     * Multiple items may have their state changed or be deleted.
     *
     * @param string $action The action to be executed.
     * @param array  $items  Identifier list of the items to be processed.
     *
     * @return bool true on sucess, false on failure.
     */
    public function handleSelectedEntries()
    {
        $this->checkCsrfToken();
        
        $redirectUrl = ModUtil::url($this->name, 'admin', 'main', array('ot' => 'extension'));
        
        $objectType = 'extension';
        
        // Get parameters
        $action = $this->request->request->get('action', null);
        $items = $this->request->request->get('items', null);
        
        $action = strtolower($action);
        
        $workflowHelper = new MUSeo_Util_Workflow($this->serviceManager);
        
        // process each item
        foreach ($items as $itemid) {
            // check if item exists, and get record instance
            $selectionArgs = array('ot' => $objectType,
                                   'id' => $itemid,
                                   'useJoins' => false);
            $entity = ModUtil::apiFunc($this->name, 'selection', 'getEntity', $selectionArgs);
        
            $entity->initWorkflow();
        
            // check if $action can be applied to this entity (may depend on it's current workflow state)
            $allowedActions = $workflowHelper->getActionsForObject($entity);
            $actionIds = array_keys($allowedActions);
            if (!in_array($action, $actionIds)) {
                // action not allowed, skip this object
                continue;
            }
        
            $hookAreaPrefix = $entity->getHookAreaPrefix();
        
            // Let any hooks perform additional validation actions
            $hookType = $action == 'delete' ? 'validate_delete' : 'validate_edit';
            $hook = new Zikula_ValidationHook($hookAreaPrefix . '.' . $hookType, new Zikula_Hook_ValidationProviders());
            $validators = $this->notifyHooks($hook)->getValidators();
            if ($validators->hasErrors()) {
                continue;
            }
        
            $success = false;
            try {
                // execute the workflow action
                $success = $workflowHelper->executeAction($entity, $action);
            } catch(\Exception $e) {
                LogUtil::registerError($this->__f('Sorry, but an unknown error occured during the %s action. Please apply the changes again!', array($action)));
            }
        
            if (!$success) {
                continue;
            }
        
            if ($action == 'delete') {
                LogUtil::registerStatus($this->__('Done! Item deleted.'));
            } else {
                LogUtil::registerStatus($this->__('Done! Item updated.'));
            }
        
            // Let any hooks know that we have updated or deleted an item
            $hookType = $action == 'delete' ? 'process_delete' : 'process_edit';
            $url = null;
            if ($action != 'delete') {
                $urlArgs = $entity->createUrlArgs();
                $url = new Zikula_ModUrl($this->name, 'extension', 'display', ZLanguage::getLanguageCode(), $urlArgs);
            }
            $hook = new Zikula_ProcessHook($hookAreaPrefix . '.' . $hookType, $entity->createCompositeIdentifier(), $url);
            $this->notifyHooks($hook);
        
            // An item was updated or deleted, so we clear all cached pages for this item.
            $cacheArgs = array('ot' => $objectType, 'item' => $entity);
            ModUtil::apiFunc($this->name, 'cache', 'clearItemCache', $cacheArgs);
        }
        
        // clear view cache to reflect our changes
        $this->view->clear_cache();
        
        return $this->redirect($redirectUrl);
    }

    /**
     * This method cares for a redirect within an inline frame.
     *
     * @param string  $idPrefix    Prefix for inline window element identifier.
     * @param string  $commandName Name of action to be performed (create or edit).
     * @param integer $id          Id of created item (used for activating auto completion after closing the modal window).
     *
     * @return boolean Whether the inline redirect has been performed or not.
     */
    public function handleInlineRedirect()
    {
        $id = (int) $this->request->query->filter('id', 0, FILTER_VALIDATE_INT);
        $idPrefix = $this->request->query->filter('idPrefix', '', FILTER_SANITIZE_STRING);
        $commandName = $this->request->query->filter('commandName', '', FILTER_SANITIZE_STRING);
        if (empty($idPrefix)) {
            return false;
        }
        
        $this->view->assign('itemId', $id)
                   ->assign('idPrefix', $idPrefix)
                   ->assign('commandName', $commandName)
                   ->assign('jcssConfig', JCSSUtil::getJSConfig());
        
        $this->view->display('extension/inlineRedirectHandler.tpl');
        
        return true;
    }
}

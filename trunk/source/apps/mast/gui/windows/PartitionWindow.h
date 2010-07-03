/***
 * millipede: PartitionWindow.h
 * Copyright Stuart Golodetz, 2009. All rights reserved.
 ***/

#ifndef H_MILLIPEDE_PARTITIONWINDOW
#define H_MILLIPEDE_PARTITIONWINDOW

#include <wx/frame.h>
#include <wx/glcanvas.h>

#include <common/partitionforests/images/AbdominalFeature.h>
#include <common/partitionforests/images/DICOMImageBranchLayer.h>
#include <common/partitionforests/images/DICOMImageLeafLayer.h>
#include <mast/models/PartitionModel.h>

namespace mp {

//#################### FORWARD DECLARATIONS ####################
typedef boost::shared_ptr<class ICommandManager> ICommandManager_Ptr;
class PartitionView;

class PartitionWindow : public wxFrame
{
	//#################### TYPEDEFS ####################
private:
	typedef PartitionModel<DICOMImageLeafLayer,DICOMImageBranchLayer,AbdominalFeature::Enum> PartitionModelT;
	typedef boost::shared_ptr<PartitionModelT> PartitionModel_Ptr;

	//#################### PRIVATE VARIABLES ####################
private:
	ICommandManager_Ptr m_commandManager;
	wxMenuBar *m_menuBar;
	PartitionView *m_view;

	//#################### CONSTRUCTORS ####################
public:
	PartitionWindow(wxWindow *parent, const std::string& title, const PartitionModel_Ptr& model, wxGLContext *context = NULL);

	//#################### PUBLIC METHODS ####################
public:
	wxGLContext *get_context() const;

	//#################### PRIVATE METHODS ####################
private:
	void connect_special_menu_items();
	void setup_gui(const PartitionModel_Ptr& model, wxGLContext *context);
	void setup_menus();

	//#################### EVENT HANDLERS ####################
public:
	//~~~~~~~~~~~~~~~~~~~~ MENUS ~~~~~~~~~~~~~~~~~~~~
	void OnMenuActionsClearHistory(wxCommandEvent&);
	void OnMenuActionsRedo(wxCommandEvent&);
	void OnMenuActionsUndo(wxCommandEvent&);
	void OnMenuFeatureToggle(wxCommandEvent& e);
	void OnMenuFileExit(wxCommandEvent&);
	void OnMenuNavigationCentreCamera(wxCommandEvent&);
	void OnMenuNavigationFitToView(wxCommandEvent&);
	void OnMenuNavigationGotoSlice(wxCommandEvent&);
	void OnMenuNavigationNextLayer(wxCommandEvent&);
	void OnMenuNavigationNextSlice(wxCommandEvent&);
	void OnMenuNavigationPanDown(wxCommandEvent&);
	void OnMenuNavigationPanLeft(wxCommandEvent&);
	void OnMenuNavigationPanRight(wxCommandEvent&);
	void OnMenuNavigationPanUp(wxCommandEvent&);
	void OnMenuNavigationPreviousLayer(wxCommandEvent&);
	void OnMenuNavigationPreviousSlice(wxCommandEvent&);
	void OnMenuNavigationZoomIn(wxCommandEvent&);
	void OnMenuNavigationZoomOut(wxCommandEvent&);
	void OnMenuSegmentationSegmentVolume(wxCommandEvent&);
	void OnMenuSelectionClearSelection(wxCommandEvent&);
	void OnMenuToolsQuantifyFeatureVolumes(wxCommandEvent&);

	//~~~~~~~~~~~~~~~~~~~~ UI UPDATES ~~~~~~~~~~~~~~~~~~~~
	void OnUpdateMenuActionsClearHistory(wxUpdateUIEvent& e);
	void OnUpdateMenuActionsRedo(wxUpdateUIEvent& e);
	void OnUpdateMenuActionsUndo(wxUpdateUIEvent& e);
	void OnUpdateMenuNavigationNextLayer(wxUpdateUIEvent& e);
	void OnUpdateMenuNavigationNextSlice(wxUpdateUIEvent& e);
	void OnUpdateMenuNavigationPreviousLayer(wxUpdateUIEvent& e);
	void OnUpdateMenuNavigationPreviousSlice(wxUpdateUIEvent& e);
	void OnUpdateMenuSelectionClearSelection(wxUpdateUIEvent& e);
	void OnUpdateForestNeeder(wxUpdateUIEvent& e);
	void OnUpdateNonEmptySelectionNeeder(wxUpdateUIEvent& e);

	//#################### EVENT TABLE ####################
	DECLARE_EVENT_TABLE()
};

}

#endif

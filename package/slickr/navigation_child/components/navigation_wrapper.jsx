import React from 'react';
import PageForm from './page_form.jsx'
import TitleBarButtons from './title_bar_buttons.jsx'
import PropTypes from 'prop-types'
import Content from "./content.jsx";
import { Formik } from 'formik';
import Yup from 'yup';

const changeTab = function(tab, actions) {
  actions.changeTab(tab)
}

const NavigationWrapper = (
  {childTypes, parent, selectablePages, navigation, actions, values, touched,
   errors, dirty, isSubmitting, handleChange, setFieldValue, handleBlur,
   handleSubmit, handleReset, loadedImages
  }) => {
    return(
      <div >
        <form onSubmit={handleSubmit} id='page_edit_content_grid'>
          <div className="title_bar" id="title_bar">
            <div id="titlebar_left">
              <span className="breadcrumb">
                <a href="/admin">Admin</a>
                <span className="breadcrumb_sep"> / </span>
                <a href={navigation.admin_navigation_path}>
                  {navigation.root.title}
                </a>
                <span className="breadcrumb_sep"> / </span>
              </span>
              <h2 id="page_title">
                {navigation.title ? 'Edit Child' : 'New Child'}
              </h2>
            </div>
            <div id="titlebar_right">
            <TitleBarButtons saveNavigation={handleSubmit.bind(this)}
                             navigation={navigation}
                             actions={actions} />
            </div>
          </div>
          <div id='page_content_form' onSubmit={handleSubmit}>
            <div className='page_editing_area' id='collection_selection'>
              <Content navigation={navigation}
                       childTypes={childTypes}
                       parent={parent}
                       selectablePages={selectablePages}
                       actions={actions}
                       values={values}
                       errors={errors}
                       touched={touched}
                       handleChange={handleChange.bind(this)}
                       setFieldValue={setFieldValue.bind(this)}
                       loadedImages={loadedImages} />
            </div>
          </div>
        </form>
      </div>
    )
  }

export default Formik({
  mapPropsToValues: (props) => ({
    child_type:     props.navigation.child_type,
    slickr_page_id: props.navigation.slickr_page_id,
    title:          props.navigation.title,
    image:          props.navigation.image,
    text:           props.navigation.text,
    link:           props.navigation.link,
    link_text:      props.navigation.link_text
  }),
  validationSchema: Yup.object().shape({
    child_type: Yup.string().required('select a type').nullable(),
    slickr_page_id: Yup.string().nullable().when('child_type', (child_type, schema) => {
      if(child_type === 'Page') {
        return schema.required('select a page');
      }
    }),
    title: Yup.string().required('select a title').nullable()
  }),
  handleSubmit: (values, { props, setErrors, setSubmitting }) => {
    // do stuff with your payload
    // e.preventDefault(), setSubmitting, setError(undefined) are
    // called before handleSubmit is. So you don't have to do repeat this.
    // handleSubmit will only be executed if form values pass validation (if you specify it).
    props.actions.updateNavigationChildContent(values)
  }
})(NavigationWrapper)

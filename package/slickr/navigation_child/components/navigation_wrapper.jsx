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

const NavigationWrapper = ({childTypes, navigation, actions, values, touched, errors, dirty, isSubmitting, handleChange, setFieldValue, handleBlur, handleSubmit, handleReset, loadedImages}) => {
  return(
    <div >
      <form onSubmit={handleSubmit} id='page_edit_content_grid'>
        <div className="title_bar" id="title_bar">
          <div id="titlebar_left">
            <span className="breadcrumb">
              <a href="/admin">Admin</a>
              <span className="breadcrumb_sep"> / </span>
              <a href="/admin/slickr_pages">Navigation Tree</a>
              <span className="breadcrumb_sep"> / </span>
              <a href={navigation.admin_navigation_path}>{navigation.title}</a>
              <span className="breadcrumb_sep"> / </span>
            </span>
            <h2 id="page_title">Edit Child</h2>
          </div>
          <div id="titlebar_right">
          <TitleBarButtons saveNavigation={handleSubmit.bind(this)} navigation={navigation} actions={actions} />
          </div>
        </div>
        <div id='page_content_form' onSubmit={handleSubmit}>
          <div className='page_editing_area' id='collection_selection'>
            <Content navigation={navigation} childTypes={childTypes} actions={actions} values={values} handleChange={handleChange.bind(this)} setFieldValue={setFieldValue.bind(this)} loadedImages={loadedImages} />
          </div>
        </div>
      </form>
    </div>
  )
}

export default Formik({
  mapPropsToValues: (props) => ({
    title:      props.navigation.title,
    image:      props.navigation.image,
    text:       props.navigation.text,
    link:       props.navigation.link,
    link_text:  props.navigation.link_text
  }),
  handleSubmit: (values, { props, setErrors, setSubmitting }) => {
    // do stuff with your payload
    // e.preventDefault(), setSubmitting, setError(undefined) are
    // called before handleSubmit is. So you don't have to do repeat this.
    // handleSubmit will only be executed if form values pass validation (if you specify it).
    props.actions.updatePageContent(values)
  }
})(NavigationWrapper)

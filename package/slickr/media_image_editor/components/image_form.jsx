import React from 'react';
import ReactDOM from 'react-dom';
import { Formik } from 'formik';
import Yup from 'yup';

const ImageForm = ({page, values, touched, errors, dirty, isSubmitting, handleChange, handleBlur, handleSubmit, handleReset}) => {
  let buttonText
  const noCrop = JSON.stringify({ x: null, y: null, width: null, height: null })
  if(JSON.stringify(values.crop_data) === noCrop) {
    buttonText = 'Update image'
  } else {
    buttonText = 'Crop & Update Image'
  }

  return(
    <form id='image_editor_form' onSubmit={handleSubmit}>
      <fieldset>
        <ol>
          <li className="input string">
            <label htmlFor="img_title">Image Caption</label>
            <input type="text"
                   name="img_title"
                   value={values.img_title}
                   onChange={handleChange} />
          </li>
          <li className="input string">
            <label htmlFor="alt_text">Alt Text</label>
            <input type="text"
                   name="alt_text"
                   value={values.alt_text}
                   onChange={handleChange} />
          </li>
          <li className="input string">
            <label htmlFor="img_credit">Credit</label>
            <input type="text"
                   name="img_credit"
                   value={values.img_credit}
                   onChange={handleChange} />
          </li>
        </ol>
      </fieldset>
      <button type="submit" disabled={isSubmitting}>{buttonText}</button>
    </form>
  )
}

export default Formik({
  mapPropsToValues: (props) => ({
    id: props.image.id,
    alt_text: props.image.additional_info['alt_text'],
    img_title: props.image.additional_info['img_title'],
    img_credit: props.image.additional_info['img_credit'],
    crop_data: props.image.crop_data
  }),
  handleSubmit: (values, { props, setErrors, setSubmitting }) => {
    // do stuff with your payload
    // e.preventDefault(), setSubmitting, setError(undefined) are
    // called before handleSubmit is. So you don't have to do repeat this.
    // handleSubmit will only be executed if form values pass validation.

    props.actions.updateImage({
      id: values.id,
      additional_info: {
        alt_text: values.alt_text,
        img_title: values.img_title,
        img_credit: values.img_credit
      }
    })
  }
})(ImageForm)

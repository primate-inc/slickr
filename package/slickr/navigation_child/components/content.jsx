import React from 'react';
import ReactDOM from 'react-dom';

export default class Content extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {
      pageSelectVisible: this.props.values.child_type === 'Page' ? true : false,
      linkVisible: this.props.values.child_type === 'Page' ? false : true
    }
  }

  componentDidUpdate(prevProps) {
    if(this.props.navigation.navigation_image.id !== prevProps.navigation.navigation_image.id) {
      this.props.setFieldValue(
        'slickr_navigation_image_attributes',
        { slickr_media_upload_id: this.props.navigation.navigation_image.id }
      )
    }
  }

  componentWillUnmount() {
    this.setState({ setExcludeList: false })
  }

  openImagePicker = () => (e) => {
    e.preventDefault();
    let page;
    if(Object.keys(this.props.loadedImages).length === 0) {
      page = 1
    } else {
      page = this.props.loadedImages.pagination_info.current_page
    }
    this.props.actions.toggleChoosingImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
  }

  removeImage = () => (e) => {
    this.props.setFieldValue(
      'slickr_navigation_image_attributes',
      { allow_destroy: true }
    )
    this.props.actions.updateNavImage({ id: null, path: null })
  }

  render() {
    const navigation = this.props.navigation
    const actions = this.props.actions
    const handleChange = this.props.handleChange
    const setFieldValue = this.props.setFieldValue
    const values = this.props.values
    const childTypeOptions = this.props.childTypes.map(function(type, index){
      if(index == 0) {
        return([
          <option key={index - 1}></option>,
          <option key={index} value={type}>{type}</option>
        ])
      } else {
        return <option key={index} value={type}>{type}</option>
      }
    })
    const selectablePageOptions = this.props.selectablePages.map(
      function(page, index) {
        if(index == 0) {
          return([
            <option key={index - 1}></option>,
            <option key={index} value={page.id}>{page.title}</option>
          ])
        } else {
          return <option key={index} value={page.id}>{page.title}</option>
        }
      }
    )
    return (
      <fieldset>
        <ol>
          <li className="input string">
            <div className="edit-wrapper">
              <label htmlFor="child_type">Type</label>
              <select value={values.child_type}
                      onChange={e => {
                        // call the built-in handleChange
                        handleChange(e)
                        // and do something about e
                        if(e.currentTarget.value == 'Page') {
                          this.setState({pageSelectVisible: true});
                          this.setState({linkVisible: false});
                          setFieldValue('link', '');
                        } else {
                          this.setState({pageSelectVisible: false});
                          this.setState({linkVisible: true});
                          setFieldValue('slickr_page_id', '');
                        }
                      }}
                      name="child_type">
                { childTypeOptions }
              </select>
              {this.props.errors.child_type && this.props.touched.child_type &&
                <p className="inline-errors">
                  {this.props.errors.child_type}
                </p>
              }
              <p className='hint_text'></p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="config_string">Config String</label>
              <input type="text"
                     name="config_string"
                     value={values.config_string}
                     onChange={handleChange} />
            </div>
          </li>
          <li className="input string" style={{
            display: this.state.pageSelectVisible ? 'block' : 'none'
          }}>
            <div className="edit-wrapper">
              <label htmlFor="slickr_page_id">Page</label>
              <select value={values.slickr_page_id}
                      onChange={e => {
                        // call the built-in handleChange
                        handleChange(e)
                        // and do something about e
                        let title = this.props.selectablePages.find(
                          function( obj ) {
                            return obj.id === parseInt(e.currentTarget.value);
                          }
                        ).title
                        setFieldValue('title', title);
                      }}
                      name="slickr_page_id">
                { selectablePageOptions }
              </select>
              {this.props.errors.slickr_page_id && this.props.touched.slickr_page_id &&
                <p className="inline-errors">
                  {this.props.errors.slickr_page_id}
                </p>
              }
              <p className='hint_text'></p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="title">Title</label>
              <input type="text"
                     name="title"
                     value={values.title}
                     onChange={handleChange} />
              {this.props.errors.title && this.props.touched.title &&
                <p className="inline-errors">{this.props.errors.title}</p>
              }
              <p className='hint-text'>Navigation title</p>
            </div>
          </li>
          <li className={`file input admin-big-title ${this.props.navigation.navigation_image.path == null ? 'no_image' : 'has_image'}`}>
            <div className="edit-wrapper">
              <label htmlFor="slickr_image_id">Image</label>
              <input type="file" onClick={this.openImagePicker()} />
              {(() => {
                let mediaUploadId = this.props.navigation.navigation_image.id
                let imagePath = this.props.navigation.navigation_image.path

                if(!(imagePath == null)) {
                  return (
                    <div className="inline-hints">
                      <img src={imagePath} />
                      <div className={`image-picker-remove ${mediaUploadId == null ? 'no_image' : 'has_image'}`}>
                        <div className="true_false image boolean input optional">
                          <div className="edit-wrapper">
                            <label className='label_remove' htmlFor='remove_navigation_image'>
                              <input type="checkbox"
                                     name='remove_navigation_image'
                                     id='remove_navigation_image'
                                     onClick={this.removeImage()} />
                            </label>
                          </div>
                        </div>
                      </div>
                    </div>
                  )
                }
              })()}
              <p className='hint-text'>Navigation image</p>
            </div>
          </li>

          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="text">Text</label>
              <textarea type="textarea"
                        name="text"
                        value={values.text}
                        onChange={handleChange} />
              <p className='hint-text'>Navigation text</p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="alt_text">Alt Text</label>
              <textarea type="textarea"
                        name="alt_text"
                        value={values.alt_text}
                        onChange={handleChange} />
              <p className='hint-text'>Navigation alt text</p>
            </div>
          </li>
          <li className="input string admin-big-title" style={{
            display: this.state.linkVisible ? 'block' : 'none'
          }}>
            <div className="edit-wrapper">
              <label htmlFor="link">Link</label>
              <input type="text"
                     name="link"
                     value={values.link}
                     onChange={handleChange} />
            {this.props.errors.link && this.props.touched.link &&
             <p className="inline-errors">
               {this.props.errors.link}
             </p>
            }
            <p className='hint-text'>Navigation link URL</p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="link_text">Link text</label>
              <input type="text"
                     name="link_text"
                     value={values.link_text}
                     onChange={handleChange} />
              <p className='hint-text'>Navigation link text</p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="alt_link_text">Alternative Link text</label>
              <input type="text"
                     name="alt_link_text"
                     value={values.alt_link_text}
                     onChange={handleChange} />
              <p className='hint-text'>Alternative navigation link text</p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}

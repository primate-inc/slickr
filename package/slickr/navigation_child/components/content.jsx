import React from 'react';
import ReactDOM from 'react-dom';

export default class Content extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      imagePath: this.props.navigation.navigation_image,
      pageSelectVisible: this.props.values.child_type === 'Page' ? true : false,
      linkAndLinkTextVisible: this.props.values.child_type === 'Header' ? false : true
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
      page = this.props.loadedImages.pagination_info.current_page + 1
    }
    this.props.actions.toggleChoosingImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) {
      this.props.actions.loadImages(page);
    }
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
                          this.setState({linkAndLinkTextVisible: true});
                        } else if (e.currentTarget.value == 'Header') {
                          this.setState({pageSelectVisible: false});
                          this.setState({linkAndLinkTextVisible: false});
                          setFieldValue('slickr_page_id', '');
                          setFieldValue('link', '');
                          setFieldValue('link_text', '');
                        } else {
                          this.setState({pageSelectVisible: false});
                          this.setState({linkAndLinkTextVisible: true});
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
          <li className="file input admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="image">Image</label>
              <input type="file" onClick={this.openImagePicker()} />
              {(() => {
                let image = this.props.navigation.image

                if(!(image == null)) {
                  if(this.state.imagePath !== this.props.navigation.image) {
                    setFieldValue('image', image)
                    this.setState({imagePath: this.props.navigation.image})
                  }
                  let splitFile = this.props.navigation.image.split('/');
                  let fileName = splitFile[splitFile.length - 1];
                  let fileNameWithImageSize = image.replace(
                    fileName, `small_${fileName}`
                  )
                  return (
                    <p className="inline-hints">
                      <img src={fileNameWithImageSize} />
                    </p>
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
          <li className="input string admin-big-title" style={{
            display: this.state.linkAndLinkTextVisible ? 'block' : 'none'
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
          <li className="input string admin-big-title" style={{
            display: this.state.linkAndLinkTextVisible ? 'block' : 'none'
          }}>
            <div className="edit-wrapper">
              <label htmlFor="link_text">Link text</label>
              <input type="text"
                     name="link_text"
                     value={values.link_text}
                     onChange={handleChange} />
              <p className='hint-text'>Navigation link text</p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}

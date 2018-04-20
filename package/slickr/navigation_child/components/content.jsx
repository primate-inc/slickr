import React from 'react';
import ReactDOM from 'react-dom';

export default class Content extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      excludeList: [],
      setExcludeList: false,
      imagePath: this.props.navigation.navigation_image
    }
  }

  componentWillUnmount() {
    this.setState({ setExcludeList: false })
  }

  openImagePicker = () => (e) => {
    e.preventDefault();
    const page = Object.keys(this.props.loadedImages).length === 0 ? 1 : (this.props.loadedImages.pagination_info.current_page + 1)
    this.props.actions.toggleChoosingImage();
    this.props.actions.toggleImagePicker();
    if(Object.keys(this.props.loadedImages).length === 0) { this.props.actions.loadImages(navigation); }
  }

  render() {
    const navigation = this.props.navigation
    const actions = this.props.actions
    const handleChange = this.props.handleChange
    const setFieldValue = this.props.setFieldValue
    const values = this.props.values
    if(this.props.childTypes.length !== 0 && !this.state.setExcludeList) {
      this.setState({
        excludeList: this.props.childTypes.find(function (obj) { return obj.value === navigation.child_type }).exclude,
        setExcludeList: true
      })
    }

    return (
      <fieldset>
        <ol>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="title">Title</label>
              <input type="text" name="title" value={values.title} onChange={handleChange} />
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
                  let fileNameWithImageSize = image.replace(fileName, `small_${fileName}`)
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
              <textarea type="textarea" name="text" value={values.text} onChange={handleChange} />
              <p className='hint-text'>Navigation text</p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="link">Link</label>
              <input type="text" name="link" value={values.link} onChange={handleChange} />
              <p className='hint-text'>Navigation link URL</p>
            </div>
          </li>
          <li className="input string admin-big-title">
            <div className="edit-wrapper">
              <label htmlFor="link_text">Link text</label>
              <input type="text" name="link_text" value={values.link_text} onChange={handleChange} />
              <p className='hint-text'>Navigation link text</p>
            </div>
          </li>
        </ol>
      </fieldset>
    );
  }
}

import NewImageAreaMultiple from "./new_image_area_multiple.jsx";
import React from 'react';
import ReactDOM from 'react-dom';

export default class ImageButton extends React.Component {
  constructor(props) {
    super(props);

		this.addImage = this.addImage.bind(this);
    this.state = {
      newImages: []
    }
  }


  addImage = () => (e) => {
    e.preventDefault()
    this.setState({
      newImages: this.state.newImages.concat([1])
    })

  }

  render() {
    const newImages = this.state.newImages.map( (image,index) => {
      return <NewImageAreaMultiple
               key={index}
               actions={this.props.actions}
               page={this.props.page}
               modalIsOpen={this.props.modalIsOpen}
               textAreaIndex={index}
               tags={this.props.tags}
               label={this.props.label}
               hint={this.props.imageObject.hint}
               newImageFieldId={this.props.newImageFieldId}
               imageObject={this.props.imageObject}
               actions={this.props.actions}
               textAreaName={`${this.props.newObject.object}[${this.props.newObject.relation}_attributes][${this.props.newObject.timestamp}-${index}]`}
               loadedImages={this.props.loadedImages}
               newObject={this.props.newObject}
               choosingActiveAdminImage={this.props.choosingActiveAdminImage}
               allowedUploadInfo={this.props.allowedUploadInfo} />
		}, this)

    return (
      <div>
        { newImages }
				<button className='button small add_object-button' onClick={this.addImage().bind(this)}>Add new image</button>
      </div>
    );
  }
}

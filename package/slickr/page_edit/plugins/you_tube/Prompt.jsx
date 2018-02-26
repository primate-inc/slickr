import React, {Component} from "react";

export default class Prompt extends Component {
  constructor(props) {
    super(props);

    this.state = {
      value: ''
    };

    this.onChange = this.onChange.bind(this);
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.value !== this.state.value) {
      this.props.onChange(this.state.value);
    }
  }

  onChange(e) {
    let value = e.target.value;
    this.setState({value: value});
  }

  render() {
    return <input type="text" placeholder={this.props.placeholder} className="mm-popup__input" value={this.state.value} onChange={this.onChange} />;
  }
}

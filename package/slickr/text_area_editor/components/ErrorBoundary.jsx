import React from 'react';
import ReactDOM from 'react-dom';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error:'' };
  }

  componentDidCatch(error, info) {
    // Display fallback UI
    this.setState({ hasError: true });
    // You can also log the error to an error reporting service
    // logErrorToMyService(error, info);
    this.setState({ ...this.state, error: error})
    console.error(error)
  }

  render() {
    if (this.state.hasError) {
    // You can render any custom fallback UI
    return <h1
      style={{backgroundColor: '#666666', color: 'white', padding: '20px'}}
    >Something went wrong.</h1>;
    }
    return this.props.children;
  }
}

export default ErrorBoundary;
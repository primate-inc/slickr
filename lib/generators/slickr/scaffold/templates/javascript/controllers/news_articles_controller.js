import { Controller } from "stimulus"
import querystring from 'querystring'
import axios from 'axios';

import * as u from 'JS/utils'

export default class extends Controller {
  static targets = [ "filterForm" ]

  // connect() {}

  getResults(filters, page) {

    const params = {'filterrific[has_category][]': filters, 'page': page}

    const url = this.filterFormTarget.dataset.url

    axios.get(url, {
      params,
      responseType: 'text',
      paramsSerializer: params => querystring.stringify(params)
    })
    .then(function (response) {
      const news_listing = document.getElementById('news_listing')
      const parser = new DOMParser();
      const newPartial = parser.parseFromString(response.data, 'text/html')
      const newElements = newPartial.querySelector('body').children
      if(page > 1) {
        const load_more_button = document.getElementById('news_load_more')
        load_more_button.remove()

        // Save visible elements and add new ones along with saved
        const elState = news_listing.innerHTML
        news_listing.innerHTML = elState + response.data
      } else {
        news_listing.innerHTML = response.data
      }

      const eventRF = new Event('ResultsFiltered')
      document.dispatchEvent(eventRF)
    })
    .catch(function (error) {
      console.log(error);
    });
  }

  getCategories() {
    const form = this.filterFormTarget;
    const elements = form.elements['filterrific[has_category][]']
    const selected = Array.from(elements).filter((el) => {
      return el.checked
    }).map((el) => el.value)
    return selected
  }

  filter(e) {
    this.getResults(this.getCategories(), 1)
  }

  loadMore(e) {
    const button = e.target
    this.getResults(this.getCategories(), button.dataset.page)
  }
}

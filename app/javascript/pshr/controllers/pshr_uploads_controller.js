import { Controller } from 'stimulus'

export default class extends Controller {

  static targets = ['uploader', 'uploads']

  connect() {
    console.log('connect uploads controller', this.element)
  }

  add(event) {
    // get Rails' response from event.detail
    const [response, status, xhr] = event.detail
    console.log('add to uploads', response)
    this.uploadsTarget.insertAdjacentHTML('beforeEnd', response.html)
  }

  reload(event) {
    // get Rails' response from event.detail
    const [response, status, xhr] = event.detail
    console.log('reload in uploads', response)
    event.target.outerHTML = response.html
  }

  remove(event) {
    event.stopPropagation()
    const upload = event.target.closest('form')
    console.log('remove from uploads', upload)
    upload.parentNode.removeChild(upload)
  }
}

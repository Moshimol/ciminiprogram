const data = {
  el: '#page',
  data() {
  return {
    inputShowed: false,
    inputVal: ''
  }
},
methods: {
  showInput() {
    this.inputShowed = true
  },
  hideInput() {
    this.inputVal = ''
    this.inputShowed = false
  },
  clearInput() {
    this.inputVal = ''
  },
  inputTyping(e) {
    this.inputVal = e.detail.value
  }
}}

const lifeCycle = ['onReady', 'onShow', 'onHide']

class Page {
  constructor(data) {
    this.vueIns = new Vue(data)
    lifeCycle.forEach(hook => {
      data[hook] && ( this[hook] = data[hook].bind(this.vueIns) )
    })
  }
}
const pageIns = new Page(data)
window.pageIns = pageIns

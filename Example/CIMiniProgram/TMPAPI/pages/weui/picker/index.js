const data = {
  el: '#page',
  data() {
  return {
    array: ['美国', '中国', '巴西', '日本'],
    index: 0,
    date: '2016-09-01',
    time: '12:01'
  }
},
methods: {
  bindPickerChange(e) {
    console.log('picker发送选择改变，携带值为', e.detail.value)
    this.index = e.detail.value
  },
  bindDateChange(e) {
    this.date = e.detail.value
  },
  bindTimeChange(e) {
    this.time = e.detail.value
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

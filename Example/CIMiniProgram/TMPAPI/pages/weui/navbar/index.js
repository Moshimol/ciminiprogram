const data = {
  el: '#page',
  created() {
  var that = this;
  Bridge.getSystemInfo({
    success: function (res) {
      this.sliderLeft = (res.windowWidth / that.tabs.length - that.sliderWidth) / 2
      this.sliderOffset = res.windowWidth / that.tabs.length * that.activeIndex
    }
  })
},
data() {
  return {
    sliderWidth: 96, // 需要设置slider的宽度，用于计算中间位置
    tabs: ["选项一", "选项二", "选项三"],
    activeIndex: 1,
    sliderOffset: 0,
    sliderLeft: 0
  }
},
methods: {
  tabClick(e) {
    this.sliderOffset = e.currentTarget.offsetLeft
    this.activeIndex = e.currentTarget.id
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

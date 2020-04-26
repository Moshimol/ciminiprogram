const data = {
  el: '#page',
  data() {
  return {
    content: 'unchanged',
  }
},
methods: {
  use() {
    this.content = 'changed'
    Bridge.nextTick(() => {
      console.log(this.$el.textContent)
      Bridge.showModal({
        content: this.$el.textContent
      })
    })
  },
  unuse() {
    this.content = 'changed'
    console.log(this.$el.textContent)
    Bridge.showModal({
      content: this.$el.textContent
    })
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

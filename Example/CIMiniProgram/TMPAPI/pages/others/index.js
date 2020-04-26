const data = {
  el: '#page',
  data() {
  return {
    list: [
      {
        id: 'liefCycle',
        name: '生命周期',
        open: false,
        pages: [
          {
            zh: 'onReady',
            url: 'on-ready/index?queryString1=5&queryString2=abc'
          },
          {
            zh: 'onShow',
            url: 'on-show/index'
          },
          {
            zh: 'onHide',
            url: 'on-hide/index'
          },
        ]
      },
    ]
  }
},
methods: {
  kindToggle(id) {
    const list = this.list
    for (let i = 0, len = list.length; i < len; ++i) {
      if (list[i].id === id) {
        list[i].open = !list[i].open
      } else {
        list[i].open = false
      }
    }
    this.list = list
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

const data = {
  el: '#page',
  data() {
  return {
    defaultSize: 'default',
    primarySize: 'default',
    warnSize: 'default',
    disabled: false,
    plain: false,
    loading: false
  }
},

methods: {
  setSize(type) {
    this[`${type}Size`] = this[`${type}Size`] === 'default' ? 'mini' : 'default'
  },
  setDisabled() {
    this.disabled = !this.disabled
  },
  setPlain() {
    this.plain = !this.plain
  },
  setLoading() {
    this.loading = !this.loading
  }
}

}

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

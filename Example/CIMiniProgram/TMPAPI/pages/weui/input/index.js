const data = {
  el: '#page',
  data() {
  return {
    showTopTips: false,

    radioItems: [
      { name: 'cell standard', value: '0' },
      { name: 'cell standard', value: '1', checked: true }
    ],
    checkboxItems: [
      { name: 'standard is dealt for u.', value: '0', checked: true },
      { name: 'standard is dealicient for u.', value: '1' }
    ],

    date: "2016-09-01",
    time: "12:01",

    countryCodes: ["+86", "+80", "+84", "+87"],
    countryCodeIndex: 0,

    countries: ["中国", "美国", "英国"],
    countryIndex: 0,

    accounts: ["微信号", "QQ", "Email"],
    accountIndex: 0,

    isAgree: false
  }
},
methods: {
  showTopTips() {
    var that = this
    this.showTopTips = true
    setTimeout(function () {
      that.showTopTips = false
    }, 3000);
  },
  radioChange(e) {
    console.log('radio发生change事件，携带value值为：', e.detail.value);
  
    var radioItems = this.radioItems;
    for (var i = 0, len = radioItems.length; i < len; ++i) {
      radioItems[i].checked = radioItems[i].value == e.detail.value;
    }
  
    this.radioItems = radioItems
  },
  checkboxChange(e) {
    console.log('checkbox发生change事件，携带value值为：', e.detail.value);
  
    var checkboxItems = this.checkboxItems, values = e.detail.value;
    for (var i = 0, lenI = checkboxItems.length; i < lenI; ++i) {
      checkboxItems[i].checked = false;
  
      for (var j = 0, lenJ = values.length; j < lenJ; ++j) {
        if (checkboxItems[i].value == values[j]) {
          checkboxItems[i].checked = true;
          break;
        }
      }
    }
  
    this.checkboxItems = checkboxItems
  },
  bindDateChange(e) {
    this.date = e.detail.value
  },
  bindTimeChange(e) {
    this.time = e.detail.value
  },
  bindCountryCodeChange(e) {
    console.log('picker country code 发生选择改变，携带值为', e.detail.value);
  
    this.countryCodeIndex = e.detail.value
  },
  bindCountryChange(e) {
    console.log('picker country 发生选择改变，携带值为', e.detail.value);
  
    this.countryIndex = e.detail.value
  },
  bindAccountChange(e) {
    console.log('picker account 发生选择改变，携带值为', e.detail.value);
  
    this.accountIndex = e.detail.value
  },
  bindAgreeChange(e) {
    this.isAgree = !!e.detail.value.length
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

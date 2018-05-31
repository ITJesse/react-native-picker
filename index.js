import {
    Platform,
    NativeModules,
    NativeAppEventEmitter,
    processColor
} from 'react-native';

const ios = Platform.OS === 'ios';
const android = Platform.OS === 'android';
const Picker = NativeModules.BEEPickerManager;
const options = {
    isLoop: false,
    pickerConfirmBtnText: 'confirm',
    pickerTitleText: 'pls select',
    pickerConfirmBtnColor: processColor('rgb(1, 186, 245)'),
    pickerTitleColor: processColor('rgb(20, 20, 20)'),
    pickerToolBarBg: processColor('rgb(232, 232, 232)'),
    pickerTextEllipsisLen: 6,
    pickerBg: processColor('rgb(196, 199, 206)'),
    pickerRowHeight: 24,
    wheelFlex: [1, 1, 1],
    pickerData: [],
    selectedValue: [],
    onPickerConfirm(){},
    onPickerCancel(){},
    onPickerSelect(){},
    pickerToolBarFontSize: 16,
    pickerFontSize: 16,
    pickerFontColor: processColor('rgb(31, 31 ,31, 1)')
};

export default {
    init(params){
        const opt = {
            ...options,
            ...params
        };
        const fnConf = {
            confirm: opt.onPickerConfirm,
            cancel: opt.onPickerCancel,
            select: opt.onPickerSelect
        };

        Picker._init(opt);
        //there are no `removeListener` for NativeAppEventEmitter & DeviceEventEmitter
        this.listener && this.listener.remove();
        this.listener = NativeAppEventEmitter.addListener('pickerEvent', event => {
            fnConf[event['type']](event['selectedValue'], event['selectedIndex']);
        });
    },

    show(){
        Picker.show();
    },

    hide(){
        Picker.hide();
    },

    select(arr, fn) {
        if(ios){
            Picker.select(arr);
        }
        else if(android){
            Picker.select(arr, err => {
                typeof fn === 'function' && fn(err);
            });
        }
    },

    toggle(){
        this.isPickerShow(show => {
            if(show){
                this.hide();
            }
            else{
                this.show();
            }
        });
    },

    isPickerShow(fn){
        //android return two params: err(error massage) and status(show or not)
        //ios return only one param: hide or not...
        Picker.isPickerShow((err, status) => {
            let returnValue = null;
            if(android){
                returnValue = err ? false : status;
            }
            else if(ios){
                returnValue = !err;
            }
            fn && fn(returnValue);
        });
    }
};

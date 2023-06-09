# $1: audio source
#     main-mic: main mic
#     top-mic: top mic
#     back-mic: back mic
#     front-mic: front mic
#     us: ultrasound
# $2: sample rate(Hz)
# $3: sample bit
# $4: channel number
# $5: capture duration(s)
# tinycap file.wav [-D card] [-d device] [-c channels] [-r rate] [-b bits] [-p period_size] [-n n_periods] [-t duration]
# sample usage: capture.sh main-mic 48000 16 2 10

rate=KHZ_192
filename=/data/unknown_mic.wav
sd_filename=/sdcard/unknown_mic.wav

case "$2" in
    "48000" )
        rate=KHZ_48
        ;;
    "96000" )
        rate=KHZ_96
        ;;
    "192000" )
        rate=KHZ_192
        ;;
esac

function enable_main_mic
{
	echo "enabling main mic"
	tinymix 'TX DEC0 MUX' 'SWR_MIC'
	tinymix 'TX SMIC MUX0' 'ADC0'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 1
	tinymix 'ADC1_MIXER Switch' 1
	tinymix 'ADC1 Volume' 6
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 1
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' $rate
}

function disable_main_mic
{
	echo "disabling main mic"
	tinymix 'TX SMIC MUX0' 'ZERO'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 0
	tinymix 'ADC1_MIXER Switch' 1
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 0
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' 'KHZ_48'
}

function enable_top_mic
{
	echo "enabling top mic"
	tinymix 'TX DEC0 MUX' 'SWR_MIC'
	tinymix 'TX SMIC MUX0' 'ADC3'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 1
	tinymix 'ADC4_MIXER Switch' 1
	tinymix 'ADC4 MUX' 'INP5'
	tinymix 'ADC4 Volume' 6
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 1
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' $rate
}

function disable_top_mic
{
	echo "disabling top mic"
	tinymix 'TX SMIC MUX0' 'ZERO'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 0
	tinymix 'ADC4_MIXER Switch' 1
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 0
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' 'KHZ_48'
}

function enable_back_mic
{
	echo "enabling back mic"
	tinymix 'TX DEC0 MUX' 'SWR_MIC'
	tinymix 'TX SMIC MUX0' 'ADC1'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 1
	tinymix 'ADC2_MIXER Switch' 1
	tinymix 'ADC2 MUX' 'INP3'
	tinymix 'HDR12 MUX' 'NO_HDR12'
	tinymix 'ADC2 Volume' 6
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 1
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' $rate
}

function disable_back_mic
{
	echo "disabling back mic"
	tinymix 'TX SMIC MUX0' 'ZERO'
	tinymix 'TX_CDC_DMA_TX_3 Channels' 'One'
	tinymix 'TX_AIF1_CAP Mixer DEC0' 0
	tinymix 'ADC2_MIXER Switch' 0
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_3' 0
	tinymix 'TX_CDC_DMA_TX_3 SampleRate' 'KHZ_48'
}

function enable_front_mic
{
	echo "PHONE HAS NO FRONT MIC!"
}

function disable_front_mic
{
	echo "PHONE HAS NO FRONT MIC!"
}

function enable_ultrasound_mic
{
	echo "enable ultrasound mic"
	tinymix 'TX DEC4 MUX' 'SWR_MIC'
	tinymix 'ADC4 ChMap' 'SWRM_TX3_CH2'
	tinymix 'TX SMIC MUX4' 'SWR_MIC9'
	tinymix 'TX_CDC_DMA_TX_4 Channels' 'One'
	tinymix 'TX_CDC_DMA_TX_4 SampleRate' $rate
	tinymix 'TX_CDC_DMA_TX_4 Format' 'S16_LE'
	tinymix 'TX_AIF2_CAP Mixer DEC4' '1'
	tinymix 'TX3 MODE' 'ADC_LP'
	tinymix 'ADC4_MIXER Switch' '1'
	tinymix 'ADC4 MUX' 'INP5'
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_4' 1
}

function disable_ultrasound_mic
{
	echo "disable ultrasound mic"
	tinymix 'ADC4 ChMap' 'SWRM_TX3_CH2'
	tinymix 'TX SMIC MUX4' 'ZERO'
	tinymix 'TX_AIF2_CAP Mixer DEC4' '0'
	tinymix 'ADC4_MIXER Switch' '1'
	tinymix 'TX3 MODE' 'ADC_NORMAL'
	tinymix 'TX_CDC_DMA_TX_4 SampleRate' 'KHZ_96'
	tinymix 'TX_CDC_DMA_TX_4 Channels' 'One'
	tinymix 'TX_CDC_DMA_TX_4 Format' 'S16_LE'
	tinymix 'MultiMedia1 Mixer TX_CDC_DMA_TX_4' 0
}


case "$1" in
    "main-mic" )
        enable_main_mic
        filename=/data/main_mic.wav
        sd_filename=/sdcard/main_mic.wav
        ;;
    "top-mic" )
        enable_top_mic
        filename=/data/top_mic.wav
        sd_filename=/sdcard/top_mic.wav
        ;;
    "back-mic" )
        enable_back_mic
        filename=/data/back_mic.wav
        sd_filename=/sdcard/back_mic.wav
        ;;
    "front-mic" )
        enable_front_mic
        filename=/data/front_mic.wav
        sd_filename=/sdcard/front_mic.wav
        ;;
    "us" )
        enable_ultrasound_mic
        filename=/data/us_mic.wav
        sd_filename=/sdcard/us_mic.wav
        ;;
    *)
        echo "Usage: capture.sh main-mic 48000 16 2 10"
        ;;
esac

if [ -z "$6" ]; then
    period_size=1024
else
    period_size=$6
fi

if [ -z "$7" ]; then
    n_periods=4
else
    n_periods=$7
fi


# start recording
echo "start recording"
tinycap $filename -r $2 -b $3 -T $5 -p $period_size -n $n_periods
ret=$?
if [ $ret -ne 0 ]; then
    echo "tinycap done, return $ret"
fi
cp $filename $sd_filename
# tear down
case "$1" in
    "main-mic" )
        disable_main_mic
        ;;
    "top-mic" )
        disable_top_mic
        ;;
    "back-mic" )
        disable_back_mic
        ;;
    "front-mic" )
        disable_front_mic
        ;;
    "us" )
        disable_ultrasound_mic
        ;;
esac


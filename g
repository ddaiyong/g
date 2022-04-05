import requests
import time
import pandas as pd
import json
import pyupbit
import datetime

def coins(current):
    url = "https://api.upbit.com/v1/market/all"
    querystring = {"isDetails":"true"}
    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)

    KRWticker = []
    BTCticker = []
    USDTticker = []

    for a in response_json:
    #     print(a['market'])
        if "KRW-" in a['market']:
            KRWticker.append(a['market'])
        elif "BTC-" in a['market']:
            BTCticker.append(a['market'])
        elif "USDT-" in a['market']:
            USDTticker.append(a['market'])    
    tickers = {
        "KRW":KRWticker,
        "BTC":BTCticker,
        "USDT":USDTticker
    }
    return tickers[current]

#암호화폐 시세조회

def coin_price(coin):
    url = "https://api.upbit.com/v1/orderbook"
    querystring = {"markets":coin}
    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)
    coin_now_price = response_json[0]["orderbook_units"][0]["ask_price"]
    return coin_now_price

def coin_volume(coin):
    url = "https://api.upbit.com/v1/candles/days"
    querystring ={"market": coin, "count": "200"}
    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)
    coin_now_volume = response_json[0]["candle_acc_trade_volume"]
    return coin_now_volume


#시세 호가 정보(Orderbook) 조회 // 호가 정보 조회

def coin_history(coin,time1='minutes',time2=""):
    url = f"https://api.upbit.com/v1/candles/{time1}/{time2}"

    querystring = {"market":coin,"count":"200"}

    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)
    # print(type(response_json))
    df = pd.DataFrame(response_json)
    return df

def coin_history_day(coin,time1='days'):
    url = f"https://api.upbit.com/v1/candles/{time1}"

    querystring = {"market":coin,"count":"200"}

    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)
    # print(type(response_json))
    df = pd.DataFrame(response_json)
    return df

def coin_history_week(coin,time1='weeks'):
    url = f"https://api.upbit.com/v1/candles/{time1}"

    querystring = {"market":coin,"count":"200"}

    response = requests.request("GET", url, params=querystring)
    response_json = json.loads(response.text)
    # print(type(response_json))
    df = pd.DataFrame(response_json)
    return df
    
tickers = coins("KRW") 

while True:

    try:
          
        ACCESS_KEY = ''
        SECRET_KEY = ''
    
        upbit = pyupbit.Upbit(ACCESS_KEY, SECRET_KEY)
        balance = upbit.get_balance()
        
        print('balace:', balance)


        # 단기 트레이딩 목적 - 소규모 자금(20만).

        # 비트+이클 상승장 체크
        bit_position = (coin_price('KRW-BTC')-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()
        bit_position1 = (coin_history_day('KRW-BTC','days')["trade_price"].loc[1]-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()
        bit_position2 = (coin_history_day('KRW-BTC','days')["trade_price"].loc[2]-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()
        bit_position3 = (coin_history_day('KRW-BTC','days')["trade_price"].loc[3]-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()
        bit_position4 = (coin_history_day('KRW-BTC','days')["trade_price"].loc[4]-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()
        bit_position5 = (coin_history_day('KRW-BTC','days')["trade_price"].loc[5]-coin_history_day('KRW-BTC','days')["trade_price"].mean())/coin_history_day('KRW-BTC','days')["trade_price"].std()

        eth_position = (coin_price('KRW-ETH')-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()
        eth_position1 = (coin_history_day('KRW-ETH','days')["trade_price"].loc[1]-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()
        eth_position2 = (coin_history_day('KRW-ETH','days')["trade_price"].loc[2]-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()
        eth_position3 = (coin_history_day('KRW-ETH','days')["trade_price"].loc[3]-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()
        eth_position4 = (coin_history_day('KRW-ETH','days')["trade_price"].loc[4]-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()
        eth_position5 = (coin_history_day('KRW-ETH','days')["trade_price"].loc[5]-coin_history_day('KRW-ETH','days')["trade_price"].mean())/coin_history_day('KRW-ETH','days')["trade_price"].std()

        combi=(bit_position+eth_position)/2
        combi1=(bit_position1+eth_position1)/2
        combi2=(bit_position2+eth_position2)/2
        combi3=(bit_position3+eth_position3)/2
        combi4=(bit_position4+eth_position4)/2
        combi5=(bit_position5+eth_position5)/2

        if combi > combi1 > combi2:

            tickers = coins("KRW")

            top_score = 0.001

            for a in tickers:
                time.sleep(1) #조사할때마다 1초의 여유타임을 만들어준다.(프로그램의 안정성을 위해)

                # 30분 흐름으로 파악

                sd_price_30m = (coin_price(a)-coin_history(a,'minutes',30)["trade_price"].mean())/coin_history(a,'minutes',30)["trade_price"].std()
                sd_price_30m_1ago = (coin_history(a,'minutes',30)["trade_price"].loc[1]-coin_history(a,'minutes',30)["trade_price"].mean())/coin_history(a,'minutes',30)["trade_price"].std()
                #sd_price_30m_2ago = (coin_history(a,'minutes',30)["trade_price"].loc[2]-coin_history(a,'minutes',30)["trade_price"].mean())/coin_history(a,'minutes',30)["trade_price"].std()

                if sd_price_30m-sd_price_30m_1ago > top_score :
                    top_score = sd_price_30m-sd_price_30m_1ago
                    top_score_ticker = a
                    top_score_price_level = sd_price_30m
                    now_price = coin_price(a)

            sd_volume_30m = (coin_volume(a)-coin_history(a,'minutes',30)["candle_acc_trade_volume"].mean())/coin_history(a,'minutes',30)["candle_acc_trade_volume"].std()
            sd_volume_30m_1ago = (coin_history(a,'minutes',30)["candle_acc_trade_volume"].loc[1]-coin_history(a,'minutes',30)["candle_acc_trade_volume"].mean())/coin_history(a,'minutes',30)["candle_acc_trade_volume"].std()
            #sd_volume_30m_2ago = (coin_history(a,'minutes',30)["candle_acc_trade_volume"].loc[2]-coin_history(a,'minutes',30)["candle_acc_trade_volume"].mean())/coin_history(a,'minutes',30)["candle_acc_trade_volume"].std()      

            if sd_price_30m < 1 and sd_volume_30m > sd_volume_30m_1ago and sd_volume_30m > 1.5 :
                print(top_score_ticker, sd_price_30m, sd_volume_30m, now_price)
                upbit.buy_market_order(a, 200000)

            else :
                print('None')

        else :
            print('None')

    except (RuntimeError, TypeError, NameError, ValueError, ConnectionError, AttributeError):
        pass

    time.sleep(1800)  
    

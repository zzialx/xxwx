//
//  SocketRocketUtility.m
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import "SocketRocketUtility.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

NSString * const kNeedPayOrderNote               = @"kNeedPayOrderNote";
NSString * const kWebSocketDidOpenNote           = @"kWebSocketdidReceiveMessageNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";

@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    int _index;
    NSTimeInterval reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,strong) NSTimer * heartBeat;

@end

@implementation SocketRocketUtility

+(SocketRocketUtility *)instance{
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

#pragma mark - **************** public methods
-(void)SRWebSocketOpenWithURLString:(NSString *)string{
    self.urlStirng = string;
    //如果是同一个url return
    if (self.socket) {
        return;
    }
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:string]]];//这里填写你服务器的地址
    
    NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);

    self.socket.delegate = self;   //SRWebSocketDelegate 协议
    
    [self.socket open];     //开始连接
}

-(void)SRWebSocketClose{
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}

#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(id)data {
    NSLog(@"socketSendData --------------- %@",data);
    
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
                  NSLog(@"socketSendData --------------- %@",data);
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                // 代码有点长，我就写个逻辑在这里好了
                [self reConnect];
                
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                
                NSLog(@"重连");
                
                [self reConnect];
            }
        } else {
            NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
            NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
        }
    });
}

#pragma mark - **************** private mothodes
//重连机制
- (void)reConnect
{
    [self SRWebSocketClose];

    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlStirng];
        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 30;
    }else{
        reConnectTime *= 30;
    }
}


//取消心跳
- (void)destoryHeartBeat
{
    WS(weakSelf);
    dispatch_main_async_safe(^{
        SS(strongSelf);
        if (strongSelf.heartBeat) {
            if ([strongSelf.heartBeat respondsToSelector:@selector(isValid)]){
                if ([strongSelf.heartBeat isValid]){
                    [strongSelf.heartBeat invalidate];
                    strongSelf.heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat
{
    WS(weakSelf);
    dispatch_main_async_safe(^{
        SS(strongSelf);
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        strongSelf.heartBeat = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:strongSelf.heartBeat forMode:NSRunLoopCommonModes];
    })
}

-(void)sentheart{
    //发送心跳 和后台可以约定发送什么内容  一般可以调用ping  我这里根据后台的要求 发送了data给他
    [self sendData:@"heart"];
}

//pingPong
- (void)ping{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
 //   [self initHeartBeat];
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接成功************************** ");
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNote object:nil];
        
      
//        NSDictionary *dic = @{
//                              @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
//                              };
//      //  NSMutableDictionary *dicData = [[NSMutableDictionary alloc]initWithDictionary:dic];
//      //  [dicData setObject:[Utils signWithDictionary:dic] forKey:@"sign"];
//        NSString *string = [self convertToJsonData:dic];
//        NSLog(@"%@",string);
//        [[SocketRocketUtility instance] sendData:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
     NSLog(@"************************** socket 连接失败**************************%@ ",error);
    if (webSocket == self.socket) {
       
        _socket = nil;
        //连接失败就重连
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self SRWebSocketClose];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidCloseNote object:nil];
    }
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    if (webSocket == self.socket) {

        LogInfo(@"************************** socket收到数据了************************** ");
        LogInfo(@"我这后台约定的 message 是 json 格式数据收到数据，就按格式解析吧，然后把数据发给调用层");
       
        NSDictionary *dicData = [NSDictionary dictionaryWithJsonString:message];
        LogInfo(@"socket收到的json数据处理之后是---------------->>>%@",dicData);
        NSString *string = [NSString stringWithFormat:@"%@",dicData[@"code"]];
            if (dicData && [dicData isKindOfClass:[NSDictionary class]]) {
                if ([string  isEqual:@"5101"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:TRNotificationMacLoginStatus object:nil];
                } else  if ([string  isEqual:@"5102"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:TRNotificationMacLoginOutStatus object:nil];
                    [GVUserDefaults standardUserDefaults].token = @"";
                    [[TR_SystemInfo mainSystem] setLogin:NO];
                    [[TR_SystemInfo mainSystem] removeUserInfo];
                    //移除别名
//                    [UMessage removeAlias:[[TR_SystemInfo mainSystem] userInfo].userId type:@"NLX_ALIAS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//                    }];
                    [self SRWebSocketClose];
                }
            }
    }
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

package net.nobien.jameson.client.test {
    
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Timer;
    
    public class MockUrlLoader extends URLLoader {
        
        private var delay:int;
        private var respondWith:*;
        
        public function MockUrlLoader(request:URLRequest = null, respondWith:* = null, delay:int = 250) {
            this.respondWith = respondWith;
            this.delay = delay;
            super(request);
        }
        
        private function finish(event:TimerEvent):void {
            var t:Timer = event.target as Timer;
            t.removeEventListener(TimerEvent.TIMER_COMPLETE, finish);
            data = respondWith;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        override public function load(request:URLRequest):void {
            var t:Timer = new Timer(delay, 1);
            t.addEventListener(TimerEvent.TIMER_COMPLETE, finish);
            t.start()
        }
        
    }

}
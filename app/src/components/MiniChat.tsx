'use client';

import { useEffect, useState } from 'react';

export function MiniChat() {
  const [isVisible, setIsVisible] = useState(false);
  const [isMinimized, setIsMinimized] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      // Show mini chat when user scrolls past hero (roughly 100vh)
      const scrolled = window.scrollY > window.innerHeight * 0.8;
      setIsVisible(scrolled);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  if (!isVisible) return null;

  return (
    <div className={`fixed bottom-6 right-6 z-40 transition-all duration-300 ${
      isMinimized ? 'w-16 h-16' : 'w-80 h-96'
    }`}>
      {/* Chat bubble */}
      <div className={`rounded-2xl bg-white shadow-2xl overflow-hidden flex flex-col h-full border border-slate-200 ${
        isMinimized ? 'items-center justify-center' : ''
      }`}>
        {/* Header */}
        <div className="bg-purple-500 text-white p-4 flex items-center justify-between">
          {!isMinimized && <h3 className="font-semibold text-sm">Chat with Mike</h3>}
          <button
            onClick={() => setIsMinimized(!isMinimized)}
            className="text-white hover:bg-purple-600 p-1 rounded transition"
            title={isMinimized ? 'Expand' : 'Minimize'}
          >
            {isMinimized ? '▢' : '−'}
          </button>
        </div>

        {!isMinimized && (
          <>
            {/* Message area */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              <div className="bg-slate-100 rounded-lg p-3 text-sm text-slate-700">
                <p className="font-semibold text-purple-600">Mike:</p>
                <p>Take your time exploring. I'm here whenever you're ready to talk.</p>
              </div>
            </div>

            {/* Input area */}
            <div className="border-t border-slate-200 p-3">
              <input
                type="text"
                placeholder="Ask me anything..."
                className="w-full px-3 py-2 bg-slate-100 rounded border border-slate-300 text-sm text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-purple-500"
              />
            </div>
          </>
        )}
      </div>
    </div>
  );
}

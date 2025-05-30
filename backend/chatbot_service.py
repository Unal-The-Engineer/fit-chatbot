import openai
from tavily import TavilyClient
from config import settings
import json
from typing import Dict, Any, List
import asyncio

class ChatbotService:
    def __init__(self):
        # Initialize OpenAI client
        self.openai_client = openai.AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        
        # Initialize Tavily client
        self.tavily_client = TavilyClient(api_key=settings.TAVILY_API_KEY)
        
        # Turkish system prompt
        self.system_prompt_tr = """
Sen profesyonel bir sanal diyetisyen ve sağlık asistanısın. Adın FitChat. Sadece beslenme, sağlık, fitness, egzersiz ve buna bağlı konularda yardım edebilirsin.

TEMEL SÜREÇ:
1. İlk sohbet: Kullanıcı hedefini sorunca (kilo vermek/almak/korumak), detaylı hesaplamalar ve öneriler ver
2. Devam eden sohbet: Normal konuşma tarzında, doğal şekilde cevap ver

SADECE HEDEF BELİRLEME AŞAMASINDA bu structured formatı kullan:

## 🎯 [Hedefe Göre Başlık]

[Kısa analiz]

### 📊 Hesaplamalarınız:
- **BMI:** [değer] ([normal/düşük/yüksek])
- **Günlük Kalori İhtiyacınız:** [değer] kalori
- **Hedefiniz için önerilen:** [değer] kalori

### 📋 Önerilerim:
- [3-4 kısa öneri]

### ✅ Sonraki Adım:
İsterseniz size özel günlük beslenme planı hazırlayabilirim.

DEVAM EDEN SOHBETTE:
- Normal paragraf şeklinde cevap ver
- Markdown kullanma, sadece düz metin
- Samimi ve yardımsever ol
- Eğer beslenme planı isterse detaylı plan hazırla
- Sorulara doğrudan cevap ver

KURAL VE KISITLAMALAR:
1. Sadece beslenme, sağlık, fitness, spor konularında yardım et
2. Bu konular dışındaki sorulara "Bu konuda yorum yapamam, sadece beslenme ve fitness konularında yardımcı olabilirim"
3. Tıbbi teşhis koyma, sadece genel beslenme tavsiyeleri ver
4. Türkçe konuş, samimi ve profesyonel ol

Sen konuşmaya şu mesajla başlayacaksın: "Merhaba! Ben senin profesyonel beslenme asistanın FitChat. Bilgilerinize göre kişiselleştirilmiş beslenme planı hazırlayabilirim. Hedefinizi öğrenebilir miyim? Kilo vermek, almak yoksa mevcut kilonuzu korumak mı istiyorsunuz?"
"""

        # English system prompt
        self.system_prompt_en = """
You are a professional virtual dietitian and health assistant. Your name is FitChat. You can only help with nutrition, health, fitness, exercise and related topics.

BASIC PROCESS:
1. Initial conversation: When user states their goal (lose/gain/maintain weight), provide detailed calculations and recommendations
2. Ongoing conversation: Respond naturally and conversationally

ONLY USE this structured format FOR GOAL SETTING:

## 🎯 [Goal-Based Title]

[Brief analysis]

### 📊 Your Calculations:
- **BMI:** [value] ([normal/low/high])
- **Daily Calorie Need:** [value] calories
- **Recommended for your goal:** [value] calories

### 📋 My Recommendations:
- [3-4 brief recommendations]

### ✅ Next Step:
If you'd like, I can create a personalized daily nutrition plan for you.

FOR ONGOING CONVERSATION:
- Respond in normal paragraph format
- Don't use markdown, just plain text
- Be friendly and helpful
- If they request a nutrition plan, provide detailed plan
- Answer questions directly

RULES AND RESTRICTIONS:
1. Only help with nutrition, health, fitness, sports topics
2. For non-related topics say "I can't comment on this topic, I can only help with nutrition and fitness"
3. Don't make medical diagnoses, only give general nutrition advice
4. Speak English, be friendly and professional

You should start the conversation with this message: "Hello! I am your professional nutrition assistant FitChat. I can prepare personalized nutrition plans based on your information. Can I learn about your goal? Do you want to lose weight, gain weight, or maintain your current weight?"
"""

    def get_initial_message(self, language: str = "tr") -> str:
        """Get initial welcome message based on language"""
        if language == "en":
            return "Hello! I am your professional nutrition assistant FitChat. I can prepare personalized nutrition plans based on your information. Can I learn about your goal? Do you want to lose weight, gain weight, or maintain your current weight?"
        else:
            return "Merhaba! Ben senin profesyonel beslenme asistanın FitChat. Bilgilerinize göre kişiselleştirilmiş beslenme planı hazırlayabilirim. Hedefinizi öğrenebilir miyim? Kilo vermek, almak yoksa mevcut kilonuzu korumak mı istiyorsunuz?"

    async def process_message(self, message: str, user_data: Dict[str, Any], language: str = "tr", conversation_history: List = None) -> str:
        """
        Process user message with GPT and web search integration
        """
        try:
            if conversation_history is None:
                conversation_history = []
                
            # Calculate user's BMR, TDEE and BMI
            bmr, tdee = self._calculate_calories(user_data)
            bmi = self._calculate_bmi(user_data)
            
            # Check if this is a goal-setting message (only if it's early in conversation)
            is_goal_setting = len(conversation_history) < 3 and self._is_goal_setting_message(message)
            
            # Create user context
            user_context = f"""
Kullanıcı Bilgileri:
- Cinsiyet: {user_data.get('gender', 'belirsiz')}
- Yaş: {user_data.get('age', 30)} yaş
- Boy: {user_data.get('height', 0)} cm
- Kilo: {user_data.get('weight', 0)} kg
- Aktivite Seviyesi: {user_data.get('activity_level', 'normal').lower()}
- Hesaplanan BMI: {bmi:.1f}
- Hesaplanan BMR (Bazal Metabolizma): {bmr:.0f} kalori
- Hesaplanan TDEE (Günlük İhtiyaç): {tdee:.0f} kalori
"""
            
            # Check if we need web search for current nutrition info
            web_info = ""
            if self._needs_web_search(message):
                web_info = await self._search_web(message)
            
            # Add instruction about response format based on message type
            format_instruction = ""
            if is_goal_setting:
                format_instruction = "\n\nBu hedef belirleme mesajı olduğu için structured markdown formatında cevap ver."
            else:
                format_instruction = "\n\nBu devam eden sohbet olduğu için normal paragraf formatında, markdown kullanmadan cevap ver."
            
            # Create the system prompt
            system_content = f"""
{self.system_prompt_tr if language == 'tr' else self.system_prompt_en}

{user_context}

{web_info}

{format_instruction}

Lütfen kullanıcının kişisel bilgilerini dikkate alarak kişiselleştirilmiş bir cevap ver.
"""
            
            # Build messages array with conversation history
            messages = [{"role": "system", "content": system_content}]
            
            # Add conversation history
            for msg in conversation_history:
                # Handle both dict and object formats
                if isinstance(msg, dict):
                    role = msg.get("role", "user")
                    content = msg.get("content", "")
                else:
                    role = getattr(msg, 'role', 'user')
                    content = getattr(msg, 'content', '')
                
                messages.append({
                    "role": role,
                    "content": content
                })
            
            # Add current user message
            messages.append({"role": "user", "content": message})
            
            # Get response from OpenAI
            response = await self.openai_client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=messages,
                max_tokens=500,
                temperature=0.7
            )
            
            return response.choices[0].message.content.strip()
            
        except Exception as e:
            return f"Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin. Hata: {str(e)}"

    def _calculate_calories(self, user_data: Dict[str, Any]) -> tuple:
        """
        Calculate BMR and TDEE using Mifflin-St Jeor Equation
        """
        try:
            weight = float(user_data.get('weight', 70))
            height = float(user_data.get('height', 170))
            gender = user_data.get('gender', 'male').lower()
            activity_level = user_data.get('activity_level', 'normal').lower()
            age = int(user_data.get('age', 30))
            
            # Calculate BMR
            if gender == 'male':
                bmr = 10 * weight + 6.25 * height - 5 * age + 5
            else:
                bmr = 10 * weight + 6.25 * height - 5 * age - 161
            
            # Activity multipliers
            activity_multipliers = {
                'passive': 1.2,
                'normal': 1.55,
                'active': 1.725
            }
            
            multiplier = activity_multipliers.get(activity_level, 1.55)
            tdee = bmr * multiplier
            
            return bmr, tdee
            
        except Exception:
            return 1600, 2000  # Default values

    def _calculate_bmi(self, user_data: Dict[str, Any]) -> float:
        """
        Calculate BMI using the formula: BMI = weight (kg) / (height (m))^2
        """
        try:
            weight = float(user_data.get('weight', 70))
            height = float(user_data.get('height', 170)) / 100  # Convert cm to meters
            bmi = weight / (height ** 2)
            return bmi
        except Exception:
            return 25.0  # Default value

    def _needs_web_search(self, message: str) -> bool:
        """
        Determine if message needs web search for current information
        """
        search_keywords = [
            'güncel', 'son', 'yeni araştırma', 'trend', 'popüler',
            'hangi besinler', 'vitamin', 'mineral', 'süpermarket',
            'marka', 'ürün', 'fiyat', 'mevsim'
        ]
        
        message_lower = message.lower()
        return any(keyword in message_lower for keyword in search_keywords)

    async def _search_web(self, query: str) -> str:
        """
        Search web using Tavily for current nutrition/fitness information
        """
        try:
            # Create search query focused on nutrition/fitness
            search_query = f"beslenme fitness {query} son araştırmalar"
            
            # Perform search
            search_results = self.tavily_client.search(
                query=search_query,
                search_depth="basic",
                max_results=3
            )
            
            # Process results
            if search_results and 'results' in search_results:
                web_context = "Güncel Bilgiler:\n"
                for result in search_results['results'][:2]:  # Use top 2 results
                    if result.get('content'):
                        web_context += f"- {result['content'][:200]}...\n"
                
                return web_context
            
            return ""
            
        except Exception as e:
            print(f"Web search error: {e}")
            return ""

    def _is_goal_setting_message(self, message: str) -> bool:
        """
        Check if the message is about setting fitness/nutrition goals
        """
        goal_keywords_tr = [
            'kilo vermek', 'kilo almak', 'kilo korumak', 'zayıflamak', 'kilo kaybetmek',
            'weight loss', 'lose weight', 'gain weight', 'maintain weight', 'zayıflama',
            'kiloma', 'hedefim', 'amaç', 'goal', 'target', 'vermek istiyorum', 'almak istiyorum'
        ]
        
        goal_keywords_en = [
            'lose weight', 'gain weight', 'maintain weight', 'weight loss', 'weight gain',
            'my goal', 'goal is', 'want to lose', 'want to gain', 'want to maintain'
        ]
        
        message_lower = message.lower()
        all_keywords = goal_keywords_tr + goal_keywords_en
        
        return any(keyword in message_lower for keyword in all_keywords) 
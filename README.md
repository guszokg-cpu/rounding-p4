# ค่าประมาณของจำนวนนับ ป.4

เว็บสื่อการสอนเรื่องค่าประมาณของจำนวนนับ ป.4 แบบ static HTML พร้อมเสียงตอบถูก/ผิด เกม แบบฝึก และแบบทดสอบท้ายบท

## ไฟล์สำคัญ

- `index.html` หน้าเว็บหลักทั้งหมด
- `sounds/` ไฟล์เสียง feedback
- `supabase/quiz_attempts.sql` SQL สำหรับสร้างตารางเก็บผลแบบทดสอบ

## เปิดใช้งานในเครื่อง

เปิด `index.html` ใน browser ได้โดยตรง หรือใช้ local server:

```bash
npx serve .
```

## ตั้งค่า Supabase เพื่อเก็บผลแบบทดสอบ

1. สร้าง project ใน Supabase
2. ไปที่ SQL Editor
3. รันไฟล์ `supabase/quiz_attempts.sql`
4. ไปที่ Project Settings > API
5. คัดลอก `Project URL` และ `anon public key`
6. เปิด `index.html` แล้วใส่ค่าที่ส่วนนี้:

```js
const SUPABASE_URL = "";
const SUPABASE_ANON_KEY = "";
```

ห้ามใส่ `service_role key` ใน `index.html` เพราะไฟล์นี้ถูกส่งไปที่ browser ของผู้ใช้ทุกคน

## Deploy ขึ้น GitHub + Vercel

1. สร้าง repository ใหม่บน GitHub
2. push ไฟล์ทั้งหมดขึ้น repository
3. เข้า Vercel แล้ว Import GitHub repository
4. Framework Preset เลือก `Other`
5. Build Command เว้นว่าง
6. Output Directory เว้นว่าง หรือใช้ root project
7. Deploy

## หมายเหตุด้านข้อมูลนักเรียน

หน้าเว็บส่งข้อมูลชื่อ นามสกุล ชั้น เลขที่ โรงเรียน คะแนน และรายละเอียดคำตอบไปยัง Supabase เฉพาะเมื่อใส่ค่า `SUPABASE_URL` และ `SUPABASE_ANON_KEY` แล้วเท่านั้น

นโยบายใน `quiz_attempts.sql` อนุญาตให้ผู้ใช้หน้าเว็บเพิ่มข้อมูลได้ แต่ไม่อนุญาตให้อ่านข้อมูลคะแนนผ่าน public anon key เพื่อป้องกันการเปิดเผยข้อมูลนักเรียน

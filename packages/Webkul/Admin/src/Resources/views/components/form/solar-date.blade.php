@props(['name' => 'due_date', 'value' => '', 'label' => ''])
<v-solar-date name="{{ $name }}" initial="{{ $value }}" label="{{ $label }}"></v-solar-date>
@pushOnce('scripts')
<script type="text/x-template" id="v-solar-date-template">
    <div class="relative" @keydown.esc.prevent="open = false">
        <label class="block">
            <span v-text="label"></span>
            <input type="hidden" :name="name" :value="value">
            <input ref="input" class="mt-2 block w-full cursor-pointer rounded border p-2 dark:bg-gray-900" type="text" readonly :value="display" :placeholder="@js(trans('customer::cheques.chooseDate'))" :aria-label="label" aria-haspopup="dialog" :aria-expanded="open" @click="open = !open" @keydown.enter.prevent="open = !open" @keydown.space.prevent="open = !open">
        </label>
        <div v-if="open" role="dialog" :aria-label="label" dir="rtl" class="absolute z-50 mt-1 rounded-lg border bg-white p-3 shadow-lg dark:bg-gray-900" style="width:20rem;max-width:90vw">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px">
                <button type="button" class="rounded border p-2" @click="navigate(-1)" aria-label="{{ trans('customer::cheques.previousMonth') }}">→</button>
                <select class="min-w-0 rounded border p-1 dark:bg-gray-900" :value="parts(anchor).month" @change="changeMonth(Number($event.target.value))" :aria-label="label">
                    <option v-for="(month, index) in months" :value="index + 1" v-text="month"></option>
                </select>
                <select class="min-w-0 rounded border p-1 dark:bg-gray-900" :value="parts(anchor).year" @change="changeYear(Number($event.target.value))" :aria-label="label">
                    <option v-for="year in years" :value="year" v-text="number(year)"></option>
                </select>
                <button type="button" class="rounded border p-2" @click="navigate(1)" aria-label="{{ trans('customer::cheques.nextMonth') }}">←</button>
            </div>
            <div style="display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:4px;text-align:center">
                <span v-for="day in weekdays" class="text-xs text-gray-500" v-text="day"></span>
                <template v-for="(day, index) in days" :key="index">
                    <button v-if="day" type="button" class="rounded p-2" :aria-pressed="value === day.iso" :aria-label="day.label" :style="value === day.iso ? {background:'#2563eb',color:'#fff'} : {}" @click="choose(day.iso)" v-text="number(day.number)"></button>
                    <span v-else></span>
                </template>
            </div>
            <div style="display:flex;justify-content:space-between;margin-top:12px">
                <button type="button" class="text-blue-600" @click="choose(iso(today()))">@lang('customer::cheques.todayDate')</button>
                <button type="button" class="text-blue-600" @click="choose('')">@lang('customer::cheques.clearDate')</button>
            </div>
        </div>
    </div>
</script>
<script type="module">
const chequeSolarParts = new Intl.DateTimeFormat('en-US-u-ca-persian', {year:'numeric',month:'numeric',day:'numeric',timeZone:'UTC'});
const chequeSolarDisplay = new Intl.DateTimeFormat('fa-IR-u-ca-persian', {year:'numeric',month:'2-digit',day:'2-digit',timeZone:'UTC'});
app.component('v-solar-date', {
    template: '#v-solar-date-template',
    props: ['name', 'initial', 'label'],
    data() { return {value:this.initial || '', open:false, anchor:this.monthStart(this.parse(this.initial) || this.today())}; },
    computed: {
        display() { const date=this.parse(this.value); return date ? chequeSolarDisplay.format(date) : ''; },
        months() { return ['فروردین','اردیبهشت','خرداد','تیر','مرداد','شهریور','مهر','آبان','آذر','دی','بهمن','اسفند']; },
        weekdays() { return ['ش','ی','د','س','چ','پ','ج']; },
        years() { const year=this.parts(this.anchor).year; return Array.from({length:61},(_,i)=>year-30+i); },
        days() {
            const offset=(this.anchor.getUTCDay()+1)%7;
            const next=this.monthStart(new Date(this.anchor.getTime()+32*86400000));
            const count=Math.round((next-this.anchor)/86400000);
            return [...Array(offset).fill(null), ...Array.from({length:count},(_,i)=>{
                const date=new Date(this.anchor.getTime()+i*86400000);
                return {number:i+1,iso:this.iso(date),label:chequeSolarDisplay.format(date)};
            })];
        },
    },
    mounted() { this.outside=(event)=>{if(!this.$el.contains(event.target))this.open=false;}; document.addEventListener('click',this.outside); },
    beforeUnmount() { document.removeEventListener('click',this.outside); },
    methods: {
        parts(date) { return Object.fromEntries(chequeSolarParts.formatToParts(date).filter(p=>p.type!=='literal').map(p=>[p.type,Number(p.value)])); },
        number(value) { return new Intl.NumberFormat('fa-IR',{useGrouping:false}).format(value); },
        today() { const date=new Date(); return new Date(Date.UTC(date.getFullYear(),date.getMonth(),date.getDate(),12)); },
        iso(date) { return date.toISOString().slice(0,10); },
        parse(value) { if(!/^\d{4}-\d{2}-\d{2}$/.test(value || ''))return null; const date=new Date(value+'T12:00:00Z');return Number.isFinite(date.getTime())&&this.iso(date)===value ? date : null; },
        monthStart(date) { return new Date(date.getTime()-(this.parts(date).day-1)*86400000); },
        navigate(direction) { this.anchor=this.monthStart(new Date(this.anchor.getTime()+(direction>0?32:-1)*86400000)); },
        shift(count) { for(let i=0;i<Math.abs(count);i++)this.navigate(Math.sign(count)); },
        changeMonth(month) { this.shift(month-this.parts(this.anchor).month); },
        changeYear(year) { this.shift((year-this.parts(this.anchor).year)*12); },
        choose(value) { this.value=value;this.open=false;this.$nextTick(()=>this.$refs.input.focus()); },
    },
});
</script>
@endPushOnce

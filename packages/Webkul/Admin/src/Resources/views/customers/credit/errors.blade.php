@if ($errors->any())
    <div role="alert" class="my-4 rounded border border-red-300 bg-red-50 p-4 text-sm text-red-700">
        @foreach ($errors->all() as $error)<p>{{ $error }}</p>@endforeach
    </div>
@endif

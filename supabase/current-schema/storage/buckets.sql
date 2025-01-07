-- Create the public bucket if it doesn't exist
insert into storage.buckets (id, name, public)
values ('attorneys', 'attorneys', true)
on conflict (id) do nothing;

-- Allow authenticated users to upload files
create policy "Authenticated users can upload attorney files"
on storage.objects for insert
to authenticated
with check (bucket_id = 'attorneys');

-- Allow public access to read files
create policy "Public users can view attorney files"
on storage.objects for select
to public
using (bucket_id = 'attorneys'); 
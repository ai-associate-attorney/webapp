CREATE TABLE task_hours_logs (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  task_id BIGINT REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  time_taken time NOT NULL,
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX task_hours_logs_task_id_idx ON task_hours_logs(task_id);
CREATE INDEX task_hours_logs_user_id_idx ON task_hours_logs(user_id);
-- run code in supabase upto this point

-- Enable RLS
ALTER TABLE task_hours_logs ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view hours logs on tasks they have access to" ON task_hours_logs
AS PERMISSIVE
FOR SELECT 
TO authenticated 
USING (
  task_id IN (
    SELECT t.id FROM tasks t
    WHERE t.matter_id IN (
      SELECT matter_id FROM matter_access WHERE shared_with_user_id = auth.uid()
    )
  )
);

CREATE POLICY "Users can create hours logs on tasks they have access to" ON task_hours_logs
AS PERMISSIVE
FOR INSERT 
TO authenticated 
WITH CHECK (
  task_id IN (
    SELECT t.id FROM tasks t
    WHERE t.matter_id IN (
      SELECT matter_id FROM matter_access WHERE shared_with_user_id = auth.uid()
    )
  )
);